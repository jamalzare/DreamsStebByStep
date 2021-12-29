//
//  TargetDetailView.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/6/21.
//

import SwiftUI
import CoreData

struct TargetDetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @State var target: Target
    @State private var currentPage = 2
    
    @State private var stepsCount: Int = 0
    @State private var reasonsCount: Int = 0
    @State private var painsCount: Int = 0
    @State private var tipsCount: Int = 0
    @State private var signsCount: Int = 0
    @State private var showEditView: Bool = false
    
    var body: some View {
        
        VStack{
            AppJustForSpacing()
            TargetDetailHeader(title: "\(target.title!)")
            
            PagerView(pageCount: 5, currentIndex: $currentPage){
                
                ReasonsList(reasonsCount: $reasonsCount, targetID: target.id!)
                PainList(painsCount: $painsCount, targetID: target.id!)
                StepsList(stepsCount: $stepsCount, targetID: target.id!)
                TipsList(tipsCount: $tipsCount, targetID: target.id!)
                SignsList(count: $signsCount, targetID: target.id!)
            }
            
            HStack(spacing:4){
                
                AppTabButton(title: "Reasons", currentTab: $currentPage, index: 0, count: $reasonsCount)
                AppTabButton(title: "Pains", currentTab: $currentPage, index: 1, count: $painsCount)
                AppTabButton(title: "Steps", currentTab: $currentPage, index: 2, count: $stepsCount)
                AppTabButton(title: "Tips", currentTab: $currentPage, index: 3, count: $tipsCount)
                AppTabButton(title: "Signs", currentTab: $currentPage, index: 4, count: $signsCount)
             
            }
            .padding(.bottom, 4)
            
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        
        
    }
    
}

struct AppTabButtonB: View {
    
    var title: String
    @Binding var currentTab: Int
    @State var index: Int
    var count: Int?
    
    var selected: Bool{
        return currentTab == index
    }
    
    var body: some View {
        VStack{
            Text(title + (selected ? ": \(count!)": ""))
                .fontWeight(.heavy)
                .animation(.interactiveSpring())
                .font(Font.system(size: selected ? 18 : 10))
                .foregroundColor(Color.black.opacity(0.5))
                .padding(.horizontal, selected ? 17: 4)
                .padding(6)
                .background(selected ? Color.white: Color.black.opacity(0.05))
                .clipShape(Capsule())
                .shadow(radius: selected ? 1:0)
                .animation(.spring())
                .onTapGesture {
                    self.currentTab = self.index
                }
        }
    }
}

struct StepsList: View {
    
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var target: Target
    @Binding var stepsCount: Int
    @EnvironmentObject var setting: AppSetting
    
    @State private var showAddView: Bool = false
    @State private var editStep: Step?
    
    @FetchRequest var steps: FetchedResults<Step>
    
    init(stepsCount: Binding<Int>, targetID: UUID) {
        
        self._stepsCount = stepsCount
        self._steps = FetchRequest(entity: Step.entity(),
                                   sortDescriptors: [NSSortDescriptor(keyPath: \Step.order, ascending: true)],
                                   predicate: NSPredicate(format: "targetID == %@", targetID as CVarArg),
                                   animation: .easeInOut)
    }
    
    var newOrder: Int{
        return (steps.map { Int($0.order) }.max() ?? 0) + 1
    }
    
    private let helpText = "What Actions do you think that will help you to achieve this dream? What steps you can do for this dream come true? Do whatever you think and feel good about it. Submit here the steps that you take, To do this TAP HERE or Tap on the Plus Button (+) and fill the form that will appear."
    
    var body: some View {
        
        VStack{
            DynamicList {
                ForEach(steps, id:\.self) { step in
                    
                    StepCardView(step: step).id(UUID())
                        .id(step.title).id(step.color).id(step.isDone)
                        .onTapGesture {
                            self.editStep = step
                            self.showAddView = true
                        }
                    
                }
                
                HelpView(text: helpText) {}
            }.onAppear{
                self.stepsCount = self.steps.count
            }
            
            AddButton{
                self.editStep = nil
                self.showAddView = true
            }
        }
        .background(Color.white)
        
        .sheet(isPresented: $showAddView){
            AddStepView(step: self.$editStep,
                        newOrder: self.newOrder)
                .environmentObject(self.target)
                .environment(\.managedObjectContext, self.moc)
                .environmentObject(self.setting)
        }
    }
    
}

struct StepCardView: View {
    @State var step: Step
    @EnvironmentObject var setting: AppSetting
    var body: some View {
        HStack{
            HStack{
                Text(step.title ?? "")
                    .fontWeight(.heavy)
                    .font(Font.system(size: setting.fontSize))
                    .lineLimit(10)
                    .foregroundColor(Color.black.opacity(0.6))
                
                if step.isDone {
                    Text("Done")
                        .fontWeight(.heavy)
                        .font(Font.system(size: setting.fontSize-4))
                        .lineLimit(10)
                        .foregroundColor(Color(hexString: step.color!).opacity(0.5))
                        .padding(2)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
                }
                
            }
            .padding(10)
            .background(Color(hexString: step.color ?? "Fa2314").opacity(0.5))
            .cornerRadius(40)
            .padding(.vertical, 7)
            
            Spacer()
        }
        
        
    }
}

struct ReasonsList: View {
    
    @EnvironmentObject var target: Target
    @Environment(\.managedObjectContext) var moc
    @Binding var reasonsCount: Int
    @State private var showAddView: Bool = false
    @State private var editText = ""
    @State private var editMode: Bool? = false
    @State private var selected: Reason?
    
    private let helpText = "In this section describe WHY you want to achieve this dream what will happen if this dream come true. How will you FEEL when you achieve this dream? Write down any reasons that help you achieve this dream and read them daily. To do this  TAP HERE or TAP On Plus Button (+)."
    
    @FetchRequest var reasons: FetchedResults<Reason>
    
    init(reasonsCount: Binding<Int>, targetID: UUID) {
        
        self._reasonsCount = reasonsCount
        self._reasons = FetchRequest(entity: Reason.entity(),
                                     sortDescriptors: [NSSortDescriptor(keyPath: \Reason.order, ascending: false)],
                                     predicate: NSPredicate(format: "targetID == %@", targetID as CVarArg),
                                     animation: .easeInOut)
    }
    
    var body: some View {
        
        VStack{
            DynamicList {
                ForEach(reasons, id:\.self) { reason in
                    VStack{
                        CardView(text: "\(reason.text ?? "") " , color: Color.green.opacity(0.20)).onTapGesture {
                            self.editText = reason.text ?? ""
                            self.selected = reason
                            self.editMode = true
                            self.showAddView = true
                        }
                    }
                }
                
                HelpView(text: helpText) {}
            }.onAppear{
                self.reasonsCount = self.reasons.count
            }
            
            AddButton {
                self.editText = ""
                self.editMode = false
                self.selected = nil
                self.showAddView = true
            }
            
            .sheet(isPresented: $showAddView){
                LongTextEditeView(title: "Add and Edit Reason",
                                  bindedText: self.$editText,
                                  editMode: self.$editMode,
                                  onDone: self.submit,
                                  onDelete: self.delete)
            }
        }
        
    }
    
    func submit(){
        if editText == "" { return }
        selected != nil ? update(): add()
    }
    
    func update(){
        selected?.text = editText
        saveMoc()
    }
    
    func add(){
        let reason = Reason(context: moc)
        reason.id = UUID()
        reason.text = editText
        reason.targetID = target.id
        let order = (reasons.map { $0.order }.max() ?? 0) + 1
        reason.order = order
        target.addToReason(reason)
        
        saveMoc()
    }
    
    func delete(){
        moc.delete(selected!)
        saveMoc()
    }
    
    func saveMoc(){
        do{
            try moc.save()
            editText = ""
            reasonsCount = reasons.count
        }catch (let error){
            print(error)
        }
    }
}

struct PainList: View {
    
    @EnvironmentObject var target: Target
    @Environment(\.managedObjectContext) var moc
    @Binding var painsCount: Int
    @State private var showAddView: Bool = false
    @State private var editText = ""
    @State private var editMode: Bool? = false
    @State private var selected: Pain?
    
    @FetchRequest var pains: FetchedResults<Pain>
    
    init(painsCount: Binding<Int>, targetID: UUID) {
        
        self._painsCount = painsCount
        self._pains = FetchRequest(entity: Pain.entity(),
                                   sortDescriptors: [NSSortDescriptor(keyPath: \Pain.order, ascending: false)],
                                   predicate: NSPredicate(format: "targetID == %@", targetID as CVarArg),
                                   animation: .easeInOut)
    }
    
    private let helpText = "What problems will you have if you do not achieve this dream?. What will bother you if you don't have this dream. Why not achieve this dream makes your life harder. Write down everything that causes you PAIN and SUFFERING if you do not achieve this dream. To do this TAP HERE or TAP On Plus Button (+)."
    
    var body: some View {
        
        VStack{
            
            DynamicList {
                ForEach(pains, id:\.self) { pain in
                    VStack{
                        CardView(text: "\(pain.text ?? "")", color: Color.red.opacity(0.10)).onTapGesture {
                            self.editText = pain.text ?? ""
                            self.selected = pain
                            self.editMode = true
                            self.showAddView = true
                        }
                    }
                }
                
                HelpView(text: helpText) {}
                
            }.onAppear{
                self.painsCount = self.pains.count
            }
            
            
            AddButton {
                self.editText = ""
                self.editMode = false
                self.selected = nil
                self.showAddView = true
            }
            
            .sheet(isPresented: $showAddView){
                LongTextEditeView(title: "Add and Edit Pain",
                                  bindedText: self.$editText,
                                  editMode: self.$editMode,
                                  onDone: self.submit,
                                  onDelete: self.delete)
            }
        }
    }
    
    func submit(){
        if editText == "" { return }
        selected != nil ? update(): add()
    }
    
    func update(){
        selected?.text = editText
        saveMoc()
    }
    
    func add(){
        let pain = Pain(context: moc)
        pain.id = UUID()
        pain.text = editText
        pain.targetID = target.id
        
        let order = (pains.map { $0.order }.max() ?? 0) + 1
        pain.order = order
        target.addToPain(pain)
        saveMoc()
    }
    
    func delete(){
        moc.delete(selected!)
        saveMoc()
    }
    
    func saveMoc(){
        do{
            try moc.save()
            editText = ""
            painsCount = pains.count
        }catch{
            print("error")
        }
    }
    
}

struct TipsList: View {
    
    @EnvironmentObject var target: Target
    @Environment(\.managedObjectContext) var moc
    @Binding var tipsCount: Int
    @State private var showAddView: Bool = false
    @State private var selected: Tips?
    
    @FetchRequest var tips: FetchedResults<Tips>
    
    init(tipsCount: Binding<Int>, targetID: UUID) {
        
        self._tipsCount = tipsCount
        self._tips = FetchRequest(entity: Tips.entity(),
                                  sortDescriptors: [NSSortDescriptor(keyPath: \Tips.order, ascending: false)],
                                  predicate: NSPredicate(format: "targetID == %@", targetID as CVarArg),
                                  animation: .easeInOut)
    }
    
    private let helpText = "This section shows you the TIPS for your actions and Steps. You can also write down the Tips, Understandings, Points, Notes that you have learned and they need to be reviewed daily and they will help you. To do this TAP HERE or TAP On Plus Button (+)."
    
    
    var body: some View {
        
        VStack{
            DynamicList {
                ForEach(tips, id:\.self) { tip in
                    VStack{
                        CardView(text: tip.text!, color: Color(hexString: tip.color!).opacity(0.20)).onTapGesture {
                            self.selected = tip
                            self.showAddView = true
                        }
                    }
                }
                HelpView(text: helpText) {}
                
            }.onAppear{
                self.tipsCount = self.tips.count
            }
            
            AddButton {
                self.selected = nil
                self.showAddView = true
            }
        }
        
        .sheet(isPresented: $showAddView){
            AddTipsView(target: self.target, tip: self.selected,
                        onDismiss: { self.tipsCount = self.tips.count},
                        showPining: true)
                .environment(\.managedObjectContext, self.moc)
        }
        
    }
}

struct SignsList: View {
    
    @EnvironmentObject var target: Target
    @Environment(\.managedObjectContext) var moc
    @Binding var count: Int
    @State private var showAddView: Bool = false
    @State private var selected: Sign?
    
    @FetchRequest var signs: FetchedResults<Sign>
    
    init(count: Binding<Int>, targetID: UUID) {
        
        self._count = count
        self._signs = FetchRequest(entity: Sign.entity(),
                                  sortDescriptors: [NSSortDescriptor(keyPath: \Tips.order, ascending: false)],
                                  predicate: NSPredicate(format: "targetID == %@", targetID as CVarArg),
                                  animation: .easeInOut)
    }
    
    private let helpText = "This section shows you the TIPS for your actions and Steps. You can also write down the Tips, Understandings, Points, Notes that you have learned and they need to be reviewed daily and they will help you. To do this TAP HERE or TAP On Plus Button (+)."
    
    
    var body: some View {
        
        VStack{
            DynamicList {
                ForEach(signs, id:\.self) { sign in
                    VStack{
                        CardView(text: sign.text!, color: Color(hexString: sign.color!).opacity(0.20)).onTapGesture {
                            self.selected = sign
                            self.showAddView = true
                        }
                    }
                }
                HelpView(text: helpText) {}
                
            }.onAppear{
                self.count = self.signs.count
            }
            
            AddButton {
                self.selected = nil
                self.showAddView = true
            }
        }
        
        .sheet(isPresented: $showAddView){
            AddSignView(target: self.target, sign: self.selected,
                        onDismiss: { self.count = self.signs.count })
                .environment(\.managedObjectContext, self.moc)
        }
        
    }
}

