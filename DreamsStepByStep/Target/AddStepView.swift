//
//  AddStepView.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/6/21.
//

import Foundation
import SwiftUI

enum ActiveSheet: Identifiable{
    case feeling, tips
    var id: Int {
        return self.hashValue
    }
}

// count not working
// delete tips need to work
// tips ispined need to work


struct AddStepView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentaionMode
    
    @EnvironmentObject var target: Target
    
    @Binding var step: Step?
    @State private var title: String = ""
    @State private var feeling: String = ""
    @State private var tips: String = ""
    @State private var color: String = DefinedColors.colors[0]
    
    @State private var activeSheet: ActiveSheet?
    var newOrder: Int = 0
    
    var body: some View {
        
        VStack{
            DynamicList {
                AppTextField(label: "Step Title:", text: $title, textAlignment: .leading)
                
                ColorsView(color: $color).padding(.top).padding(.top)
                
                VStack(spacing: 4){
                    
                    AppLabel(title: "Feeling")
                    AppSubLabel(title: "How Do You Feel: ")
                    
                    CardView(text: feeling,
                             color: Color(hexString: color).opacity(0.20),
                             metaText: " Tap To Edit").onTapGesture {
                                self.activeSheet = .feeling
                    }
                    
                }.padding(.top).padding(.top)
                
                if step != nil{
                    VStack(spacing: 4){
                        AppLabel(title: "Tips")
                        AppSubLabel(title: "What did you learn during this Step: ")
                        CardView(text: step?.tip?.text ?? "",
                                 color: Color(hexString: step?.tip?.color ?? color).opacity(0.20),
                                 metaText: " Tap To Edit").onTapGesture {
                                    self.activeSheet = .tips
                        }
                        
                    }.padding(.vertical).padding(.top)
                }
                
                HStack{
                    Spacer()
                    SubmitButton { self.submit() }
                    if step != nil{
                        DeleteButton { self.delete() }
                    }
                    CancelButton{ self.dismiss() }
                    Spacer()
                }.padding()
                
            }.padding(.top)
            
        }
        .onAppear{
            if let step = self.step{
                self.title = step.title ?? ""
                self.color = step.color ?? ""
                self.feeling = step.feeling ?? ""
                self.tips = step.tip?.text ?? ""
            }
        }
        .sheet(item: $activeSheet){ sheet in
            if sheet == .feeling{
                LongTextEditeView(title: "Edit your Feeling here",
                                  bindedText: self.$feeling,
                                  editMode: .constant(nil))
            }else{
//                AddTipsView(target: self.target,
//                            step: self.step,
//                            tip: self.step?.tip,
//                            showPining: true)
//                    .environment(\.managedObjectContext, self.moc)
                
            }
        }
    }
    
    
    func showFeelingEdit(){
        //self.presentaionMode.
    }
    
    func submit(){
        if title == "" { return }
        step == nil ? add() : update()
    }
    
    func add(){
        
        let step = Step(context: moc)
        step.id = UUID()
        
        step.title = title
        step.color = color
        step.feeling = feeling
        step.order = Int32(newOrder)
        
        step.targetID = target.id
        target.addToSteps(step)
        
        saveMoc()
    }
    
    
    func update(){
        
        if let step = step{
            step.title = title
            step.color = color
            step.feeling = feeling
            saveMoc()
        }
    }
    
    func delete(){
        if let step = step {
            if let tip = step.tip{
                moc.delete(tip)
            }
            moc.delete(step)
            saveMoc()
        }
    }
    
    func saveMoc(){
        do{
            try moc.save()
            dismiss()
        }catch{
            print("UNsaved")
        }
    }
    
    func dismiss(){
        presentaionMode.wrappedValue.dismiss()
    }
}


struct AddStepView_Previews: PreviewProvider {
    static var previews: some View {
        AddStepView(step: .constant(Step())).environmentObject(Target())
    }
}

struct PinButton: View {
    @Binding var on: Bool
    
    var body: some View {
        Image(systemName:  on ? "pin.fill": "pin")
            .rotationEffect(Angle(degrees: on ? 90:0))
            .font(Font.system(size: 20, weight: .heavy))
            .foregroundColor(Color.black.opacity(0.5))
            .padding()
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 2)
            
            .onTapGesture {
                self.on.toggle()
        }
    }
}

