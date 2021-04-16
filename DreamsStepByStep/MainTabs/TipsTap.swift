//
//  TipsTap.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/7/21.
//

import Foundation
import SwiftUI

struct TipsTap: View {
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(
        entity: Tips.entity(),
        sortDescriptors: [
             NSSortDescriptor(keyPath: \Tips.order, ascending: false)
        ],
        predicate: NSPredicate(format: "isPinned = true")
        
    ) var tips: FetchedResults<Tips>
    
    
    @State private var showAddView = false
    @State private var selectedTip: Tips?
    
    private var helpText = "What did you understand or learn today? What do you need review daily? Add Here Tips, Understandings, Points, Notes for Daily review, to Add Tips TAP HERE or TAP On Plus Button (+) and in the form that will Apear type the tips that you want to review daily and select a color for beautify it then submit it."
    
    var body: some View {
        
        VStack(spacing:0) {
            
            titleView(title: "Tips: \(tips.count) ")
            
            DynamicList {
                
                ForEach(tips, id:\.self){ tip in
                    Button(action: {
                        self.selectedTip = tip
                        self.showAddView.toggle()
                    }){
                        CardView(text: "\(tip.text!)", color: Color(hexString: tip.color!).opacity(0.20))
                    }
                }
                HelpView(text: helpText){}
                
            }
            AddButton{
                self.selectedTip = nil
                self.showAddView = true
            }
        }
        .sheet(isPresented: $showAddView){
            AddTipsView(tip: self.selectedTip)
                .environment(\.managedObjectContext, self.moc)
        }
        
    }
    
    
}

struct TipsTap_Previews: PreviewProvider {
    static var previews: some View {
        TipsTap()
    }
}


