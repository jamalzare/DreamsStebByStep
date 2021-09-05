//
//  TodayTab.swift
//  DreamsStepByStep
//
//  Created by Jamal on 9/5/21.
//

import Foundation
import SwiftUI

struct TodayTab: View {
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(
        entity: Today.entity(),
        sortDescriptors: [
             NSSortDescriptor(keyPath: \Today.order, ascending: false)
        ]
        
    ) var todays: FetchedResults<Today>
    
    
    @State private var showAddView = false
    @State private var selectedToday: Today?
    
    private var helpText = "What happend today? what did you do today? in this tab TAP On Plus Button (+) and in the form that will apear type the things that you happy about today and describe the why you happy about that and then select a color for beautify it then submit it."
    
    var body: some View {
        
        VStack(spacing:0) {
            
            titleView(title: "Today: \(todays.count) ")
            
            DynamicList {
                
                ForEach(todays, id:\.self){ today in
                    Button(action: {
                        self.selectedToday = today
                        self.showAddView.toggle()
                    }){
                        CardView(text: "\(today.text!)", color: Color(hexString: today.color!).opacity(0.20))
                    }
                }
                HelpView(text: helpText){}
                
            }
            AddButton{
                self.selectedToday = nil
                self.showAddView = true
            }
        }
        .sheet(isPresented: $showAddView){
            AddTodayView(today: self.selectedToday)
                .environment(\.managedObjectContext, self.moc)
        }
        
    }
}
