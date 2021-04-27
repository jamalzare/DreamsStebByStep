//
//  AddTipsView.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/7/21.
//

import Foundation
import SwiftUI

// check for is Pinned

struct AddTipsView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentaionMode
    
    @FetchRequest(
        entity: Tips.entity(),
        sortDescriptors: [
            //NSSortDescriptor(keyPath: \Target, ascending: false)
        ]
    ) var tips: FetchedResults<Tips>
    
    @State private var text: String = ""
    @State private var color: String = DefinedColors.colors[0]
    @State private var isPinned: Bool = true
    
    var target: Target?
    var step: Step?
    var tip: Tips?
    var onDismiss = {}
    
    var showPining: Bool = false
    
    var body: some View {
        
        DynamicList {
            
            AppLabel(title: "What did you learn today? ")
            
//            TextEditor(text: $text)
//                .frame(height: 250)
//                .padding(10)
//                .overlay(RoundedRectangle(cornerRadius: 40)
//                    .stroke(Color.black.opacity(0.1), lineWidth: 1))
            
//
            AppTextEditor(text: $text)
               // .id(text.hashValue)
            
            ColorsView(color: $color).padding(.top)
            
            if showPining{
                VStack{
                    AppSubLabel(title: "For reviewing above tip in the Tips Tab you need to turn on the pin by below button or if you don't want, turn it off.")
                    
                    HStack{
                        AppLabel(title: "Pin the Tips")
                        PinButton(on: $isPinned)
                    }
                }
            }
            
            HStack{
                Spacer()
                SubmitButton { self.submit() }
                if tip != nil{
                    DeleteButtonWithAlert { self.delete() }
                }
                CancelButton{ self.dismiss() }
                Spacer()
            }.padding()
            
            Spacer()
            
        }.onAppear{
            self.isPinned = self.showPining ? false: true
            if let tip = self.tip{
                self.text = tip.text!
                self.color = tip.color!
                self.isPinned = tip.isPinned
            }
        }
       
        
    }
    
    func submit(){
        tip == nil ? add(): update()
    }
    
    func add(){
        if text == "" {
            return
        }
        let tip = Tips(context: moc)
        tip.text = text
        tip.color = color
        tip.isPinned = isPinned
        tip.id = UUID()
        tip.order = (tips.map { $0.order }.max() ?? 0) + 1
        
        if let target = target{
            tip.targetID = target.id
            target.addToTips(tip)
        }
        if let step = step{
            tip.stepID = step.id
            step.tip = tip
        }
        
        saveMoc()
    }
    
    func delete(){
        if let tip = tip{
            moc.delete(tip)
            saveMoc()
        }
    }
    
    func update(){
        if text == "" { return }
        if let tip = tip{
            tip.text = text
            tip.color = color
            tip.isPinned = isPinned
            saveMoc()
        }
    }
    
    func saveMoc(){
        do {
            try moc.save()
            dismiss()
        }catch{
            print("Erro on delete tip")
        }
    }
    func dismiss(){
        presentaionMode.wrappedValue.dismiss()
        text = ""
        color = DefinedColors.colors[0]
        isPinned = showPining ? false: true
        onDismiss()
    }
}
//
//struct AddTipsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTipsView()
//    }
//}
