//
//  Test.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/28/21.
//

import Foundation
import SwiftUI
import CoreData

struct TestList: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var target: Target
    @Binding var stepsCount: Int
    @EnvironmentObject var setting: AppSetting
    
    @State private var showAddView: Bool = false
    @State private var editStep: Step?
    
    //@State var tr: Target
    
    //    var steps : [Step] {
    //        print(target.id)
    //        return (tr.steps?.allObjects as? [Step] ?? [Step]()).sorted {
    //            $0.order < $1.order
    //        }
    //    }
    
    @FetchRequest
    var steps: FetchedResults<Step>
    
    init(stepsCount: Binding<Int>) {
        self._stepsCount = stepsCount
        
        let id = "77085F4F-731E-475A-99E3-48EE434FC090"
        let uid = UUID(uuidString: id)
        
        self._steps = FetchRequest(entity: Step.entity(), sortDescriptors: [],
                                  
                                    predicate: NSPredicate(format: "targetID == %@",
                                                         //  #keyPath(Event.task),
                                                           uid! as CVarArg),
                                    animation: .default)
    }
    
    var newOrder: Int {
        return (steps.map { Int($0.order) }.max() ?? 0) + 1
    }
    
    private let helpText = "What Actions do you think that will help you to achieve this dream? What steps you can do for this dream come true? Do whatever you think and feel good about it. Submit here the steps that you take, To do this TAP HERE or Tap on the Plus Button (+) and fill the form that will appear."
    
    var body: some View {
        
        VStack{
            DynamicList {
                ForEach(steps) { step in
                    
                    Button(action: {
                        // self.selectedThank = thank
                        self.editStep = step
                        self.showAddView.toggle()
                    }){
                        CardView(text: "\(step.title!)", color: Color(hexString: step.color!).opacity(0.20))
                    }
                    
                }
                
                HelpView(text: helpText) {}
            }.onAppear{
                self.stepsCount = self.steps.count
                getData()
                // self.tr = target
            }
            
            AddButton{
                self.editStep = nil
                self.showAddView = true
            }
        }
        .background(Color.white)
        
        .fullScreenCover(isPresented: $showAddView){
            AddStepView(step: self.$editStep,
                        newOrder: self.newOrder)
                .environment(\.managedObjectContext, self.moc)
                .environmentObject(self.setting)
                .onDisappear{
                    getData()
                    self.editStep = nil
                    self.showAddView = false
                }
        }
    }
    
    func getData() {
        
        let fetchRequest: NSFetchRequest<Step> = Step.fetchRequest()
        fetchRequest.predicate =  NSPredicate(format: "targetID == '\(target.id!.uuidString)'")
        do {
            
            let steps = try moc.fetch(fetchRequest)
            //  self.steps = steps
            
        } catch {
            
            print("Error in fetching count of the Accounts.")
            
        }
    }
    
}
