//
//  TargetsTab.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/6/21.
//

import SwiftUI

struct TargetsTab: View {
        
        @Environment(\.managedObjectContext) var moc
        @FetchRequest(
            entity: Target.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Target.order, ascending: false)
            ]
        ) var targets: FetchedResults<Target>
        
        @State private var showAddView = false
        @State private var showDetailView = false
        @State private var selectedTarget: Target?
        
        @State private var editTarget: Target?
        
        private var helpText = "What Dreams Do you have? What goals do you want to achieve? what are your targets? Add Your dreams, goals, targets, desires here to work on it, TAP HERE or TAP On Plus Button (+) and in the form that will apear, type your dream title and choose a color just for beautify it and then submit it. For Edit a dream long press or long tab on that dream."
        
        var body: some View {
            VStack{
                titleView(title: "Dreams: \(targets.count)")
                
                if selectedTarget != nil {
                    NavigationLink("", destination: TargetDetailView(target: selectedTarget!)
                                    .environmentObject(selectedTarget!),
                                    isActive: self.$showDetailView)
                }
                
                List{
                    ForEach(targets, id:\.self) { target in
                        VStack{
                            TargetCard(target: target)
                                .id(target.title).id(target.color)
                                .onTapGesture { self.navigateToDetail(target) }
                                .onLongPressGesture { self.presentEditView(target)}
                        }
                        .background(Color.white)
                    }
                    .background(Color.white)
                    
                    HelpView(text: helpText) {}
                }
                
                AddButton{ self.presentAddView() }
            }
            .background(Color.white)
                
            .sheet(isPresented: $showAddView){
                AddTargetView(editTarget: self.$editTarget)
                    .environment(\.managedObjectContext, self.moc)
            }
            
        }
        
        func navigateToDetail(_ target: Target){
            selectedTarget = target
            showDetailView = true
        }
        
        func presentEditView(_ target: Target){
            editTarget = target
            showAddView = true
        }
        
        func presentAddView(){
            editTarget = nil
            showAddView = true
        }
        
    }

    struct Tab1Content_Previews: PreviewProvider {
        static var previews: some View {
            TargetsTab()
        }
    }


    struct TargetCard: View {
        @State var target: Target
        @EnvironmentObject var setting: AppSetting
        
        var body: some View {
            Text("\(target.title!)")
                .fontWeight(.heavy)
                .foregroundColor(Color.black.opacity(0.5))
                .font(Font.system(size: setting.fontSize))
                .lineLimit(1)
                .padding(12)
               .background(Color(hexString: target.color!).opacity(0.5))
                .clipShape(Capsule())
                .frame(maxWidth: .infinity, minHeight:100, alignment: .center)
        }
    }


struct TargetsTab_Previews: PreviewProvider {
    static var previews: some View {
        TargetsTab()
    }
}

struct AddTargetView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentaionMode
    
    @FetchRequest(
        entity: Target.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Target.order, ascending: false)
        ]
    ) var targets: FetchedResults<Target>
    
    @Binding var editTarget: Target?
    
    @State private var title: String = ""
    @State private var color: String = DefinedColors.colors[0]
    @State private var editMode = false
    
    
    var body: some View {
        List{
            AppTextField(label: "Type a title for your Dream:", text: $title).padding(.top)
            ColorsView(color: $color).padding(.vertical)
            
            HStack{
                Spacer()
                SubmitButton { self.submit()}

                if editMode{
                    DeleteButton{ self.delete() }
                }
                CancelButton{ self.getBack() }
                Spacer()
            }
        }
        .onAppear{
            if let target = self.editTarget{
                self.title = target.title!
                self.color = target.color!
                self.editMode = true
            }
        }
    }
    
    
    func submit(){
        editMode ? update(): add()
    }
    
    func add(){
        if title == "" {
            return
        }
        let target = Target(context: moc)
        target.title = title
        target.color = color
        target.id = UUID()

        target.order = targets.count>0 ? targets[0].order + 1: 0

        mocSave()
        
    }
    
    func update(){
        if title == "" {
            return
        }
        editTarget?.title = title
        editTarget?.color = color
        mocSave()
    }
    
    func delete(){
        if let target = editTarget{
            moc.delete(target)
            mocSave()
        }
    }
    
    func mocSave(){
        do {
            try moc.save()
            getBack()
        }catch{
            print("error on saving")
        }
    }
    
    func getBack(){
        presentaionMode.wrappedValue.dismiss()
        title = ""
        color = DefinedColors.colors[0]
    }
    
}
//struct AddTargetView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTargetView(editTarge: .constant(nil))
//    }
//}



