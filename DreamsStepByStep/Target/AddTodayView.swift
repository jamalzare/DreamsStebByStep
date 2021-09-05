//
//  AddTodayView.swift
//  DreamsStepByStep
//
//  Created by Jamal on 9/5/21.
//

import Foundation
import SwiftUI

struct AddTodayView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentaionMode
    
    @FetchRequest(
        entity: Today.entity(),
        sortDescriptors: [
            //NSSortDescriptor(keyPath: \Target, ascending: false)
        ]
    ) var todays: FetchedResults<Today>
    
    @State private var text: String = ""
    @State private var color: String = DefinedColors.colors[0]
    
    var today: Today?
    var onDismiss = {}
    
    var body: some View {
        
        DynamicList {
            
            AppLabel(title: "What do happend today? ")
            
            MultiLineTextField(text: $text)
                .frame(height: 300)
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.black.opacity(0.1), lineWidth: 1))
            
            
            ColorsView(color: $color).padding(.top)
            
            HStack{
                Spacer()
                SubmitButton { self.submit() }
                if today != nil{
                    DeleteButtonWithAlert { self.delete() }
                }
                CancelButton{ self.dismiss() }
                Spacer()
            }.padding()
            
            Spacer()
            
        }.onAppear{
           
            if let today = self.today {
                self.text = today.text!
                self.color = today.color!
            }
        }
       
        
    }
    
    func submit(){
        today == nil ? add(): update()
    }
    
    func add(){
        if text == "" {
            return
        }
        let today = Today(context: moc)
        today.text = text
        today.color = color
        today.id = UUID()
        today.order = (todays.map { $0.order }.max() ?? 0) + 1
        
        saveMoc()
    }
    
    func delete(){
        if let today = today {
            moc.delete(today)
            saveMoc()
        }
    }
    
    func update(){
        
        if text == "" { return }
        
        if let today = today {
            today.text = text
            today.color = color
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
