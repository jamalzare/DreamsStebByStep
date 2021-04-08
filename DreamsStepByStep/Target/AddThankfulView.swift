//
//  AddThankfulView.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/8/21.
//

import Foundation
import SwiftUI

struct AddThankfulView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentaionMode
    
    @FetchRequest(
        entity: Thankful.entity(),
        sortDescriptors: [
            //NSSortDescriptor(keyPath: \Target, ascending: false)
        ]
    ) var thanks: FetchedResults<Thankful>
    
    @State private var text: String = ""
    @State private var color: String = DefinedColors.colors[0]
    
    var thank: Thankful?
    var onDismiss = {}
    
    var body: some View {
        
        List{
            
            AppLabel(title: "What do you thankful for? ")
            
            MultiLineTextField(text: $text)
                .frame(height: 300)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.black.opacity(0.1), lineWidth: 1))
            
            
            ColorsView(color: $color).padding(.top)
            
            HStack{
                Spacer()
                SubmitButton { self.submit() }
                if thank != nil{
                    DeleteButton{ self.delete() }
                }
                CancelButton{ self.dismiss() }
                Spacer()
            }.padding()
            
            Spacer()
            
        }.onAppear{
           
            if let thank = self.thank{
                self.text = thank.text!
                self.color = thank.color!
            }
        }
       
        
    }
    
    func submit(){
        thank == nil ? add(): update()
    }
    
    func add(){
        if text == "" {
            return
        }
        let thank = Thankful(context: moc)
        thank.text = text
        thank.color = color
        thank.id = UUID()
        thank.order = (thanks.map { $0.order }.max() ?? 0) + 1
        
        saveMoc()
    }
    
    func delete(){
        if let thank = thank {
            moc.delete(thank)
            saveMoc()
        }
    }
    
    func update(){
        
        if text == "" { return }
        
        if let thank = thank {
            thank.text = text
            thank.color = color
            saveMoc()
        }
    }
    
    func saveMoc(){
        do {
            try moc.save()
            dismiss()
        }catch{
            print("Erro on delete thank")
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
