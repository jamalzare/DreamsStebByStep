//
//  DesiresTab.swift
//  DreamsStepByStep
//
//  Created by Jamal on 9/12/21.
//

import Foundation
import SwiftUI

struct DesiresTab: View {
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(
        entity: Desire.entity(),
        sortDescriptors: [
             NSSortDescriptor(keyPath: \Desire.order, ascending: false)
        ]
        
    ) var desires: FetchedResults<Desire>
    
    
    @State private var showAddView = false
    @State private var selectedDesire: Desire?
    
    private var helpText = "What do you want for today? what desires you habe for your life? in this tab TAP On Plus Button (+) and in the form that will apear type the things that you want and let the universe to do it for you and then select a color for beautify it then submit it."
    
    var body: some View {
        
        VStack(spacing:0) {
            
            titleView(title: "Desires: \(desires.count) ")
            
            DynamicList {
                
                ForEach(desires, id:\.self){ desire in
                    Button(action: {
                        self.selectedDesire = desire
                        self.showAddView.toggle()
                    }){
                        DesireCardView(desire: desire).id(UUID())
                            .id(desire.title).id(desire.color).id(desire.isDone)
                            .onTapGesture {
                                self.selectedDesire = desire
                                self.showAddView = true
                            }
                    }
                }
                HelpView(text: helpText){}
                
            }
            AddButton{
                self.selectedDesire = nil
                self.showAddView = true
            }
        }
        .sheet(isPresented: $showAddView){
            AddDesireView(desire: self.selectedDesire)
                .environment(\.managedObjectContext, self.moc)
        }
        
    }
}

struct DesireCardView: View {
    @State var desire: Desire
    @EnvironmentObject var setting: AppSetting
    var body: some View {
        HStack{
            HStack{
                Text(desire.title ?? "")
                    .fontWeight(.heavy)
                    .font(Font.system(size: setting.fontSize))
                    .lineLimit(10)
                    .foregroundColor(Color.black.opacity(0.6))
                    
                
                if desire.isDone {
                    Text("Done")
                        .fontWeight(.heavy)
                        .font(Font.system(size: setting.fontSize-4))
                        .lineLimit(10)
                        .foregroundColor(Color(hexString: desire.color!).opacity(0.5))
                        .padding(2)
                        .background(Color.white)
                        .clipShape(Capsule())
                    
                }
                
            }
            .padding(10)
            .background(Color(hexString: desire.color ?? "Fa2314").opacity(0.5))
            .cornerRadius(40)
            .padding(.vertical, 7)
            
            Spacer()
        }
        
        
    }
}
