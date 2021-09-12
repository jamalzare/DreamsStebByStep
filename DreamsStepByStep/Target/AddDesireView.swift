//
//  AddDesireView.swift
//  DreamsStepByStep
//
//  Created by Jamal on 9/12/21.
//

import Foundation
import SwiftUI

struct AddDesireView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentaionMode
    
    @FetchRequest(
        entity: Desire.entity(),
        sortDescriptors: [
            //NSSortDescriptor(keyPath: \Target, ascending: false)
        ]
    ) var desires: FetchedResults<Desire>
    
    var desire: Desire?
    @State private var title: String = ""
    @State private var isDone: Bool = false
    @State private var color: String = DefinedColors.colors[0]
    
    @State private var activeSheet: ActiveSheet?
    var newOrder: Int = 0
    
    var onDismiss = {}
    
    var body: some View {
        
        DynamicList {
            
            HStack {
                AppTextField(label: "Desire Title:", text: $title, textAlignment: .leading)
                
                if desire != nil {
                    Button(action: {
                        isDone.toggle()
                        update()
                    }){
                        Text("Done")
                            .font(Font.system(size: 14, weight: .heavy))
                            .foregroundColor(Color.black.opacity(0.6))
                            .padding(10)
                            .background(isDone ? Color(hexString: color).opacity(0.20): lightBlack)
                            .cornerRadius(26)
                            .lineLimit(1)
                            .padding(.top, 50)
                            .padding(.leading, 4)
                    }
                }
            }
            
            
            ColorsView(color: $color).padding(.top)
            
            HStack{
                Spacer()
                SubmitButton { self.submit() }
                if desire != nil{
                    DeleteButtonWithAlert { self.delete() }
                }
                CancelButton{ self.dismiss() }
                Spacer()
            }.padding()
            
            Spacer()
            
        }.onAppear{
           
            if let desire = self.desire {
                self.title = desire.title!
                self.isDone = desire.isDone
                self.color = desire.color!
            }
        }
       
        
    }
    
    func submit(){
        desire == nil ? add(): update()
    }
    
    func add(){
        if title == "" {
            return
        }
        let desire = Desire(context: moc)
        desire.title = title
        desire.color = color
        desire.isDone = false
        desire.id = UUID()
        desire.order = (desires.map { $0.order }.max() ?? 0) + 1
        
        saveMoc()
    }
    
    func delete(){
        if let desire = desire {
            moc.delete(desire)
            saveMoc()
        }
    }
    
    func update(){
        
        if title == "" { return }
        
        if let desire = desire {
            desire.title = title
            desire.color = color
            desire.isDone = isDone
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
        title = ""
        color = DefinedColors.colors[0]
        onDismiss()
    }
}

