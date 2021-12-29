//
//  AddSignView.swift
//  DreamsStepByStep
//
//  Created by Jamal on 12/29/21.
//

import Foundation
import SwiftUI


struct AddSignView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentaionMode
    
    @FetchRequest(
        entity: Sign.entity(),
        sortDescriptors: [
            //NSSortDescriptor(keyPath: \Target, ascending: false)
        ]
    ) var signs: FetchedResults<Sign>
    
    @State private var text: String = ""
    @State private var color: String = DefinedColors.colors[0]
    
    var target: Target?
    var sign: Sign?
    var onDismiss = {}
    
    var body: some View {
        
        DynamicList {
            
            AppLabel(title: "What Signs yow saw in your path? ")
            
//            TextEditor(text: $text)
//                .frame(height: 250)
//                .padding(10)
//                .overlay(RoundedRectangle(cornerRadius: 40)
//                    .stroke(Color.black.opacity(0.1), lineWidth: 1))
            
//
            AppTextEditor(text: $text)
               // .id(text.hashValue)
            
            ColorsView(color: $color).padding(.top)
            
            HStack{
                Spacer()
                SubmitButton { self.submit() }
                if sign != nil{
                    DeleteButtonWithAlert { self.delete() }
                }
                CancelButton{ self.dismiss() }
                Spacer()
            }.padding()
            
            Spacer()
            
        }.onAppear{
            if let sign = self.sign {
                self.text = sign.text!
                self.color = sign.color!
            }
        }
       
        
    }
    
    func submit(){
        sign == nil ? add(): update()
    }
    
    func add(){
        if text == "" {
            return
        }
        let sign = Sign(context: moc)
        sign.text = text
        sign.color = color
        sign.id = UUID()
        sign.order = (signs.map { $0.order }.max() ?? 0) + 1
        
        if let target = target{
            sign.targetID = target.id
            target.addToSigns(sign)
        }
        
        saveMoc()
    }
    
    func delete(){
        if let sign = sign {
            moc.delete(sign)
            saveMoc()
        }
    }
    
    func update(){
        if text == "" { return }
        if let sign = sign {
            sign.text = text
            sign.color = color
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
        onDismiss()
    }
}
//
//struct AddTipsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTipsView()
//    }
//}
