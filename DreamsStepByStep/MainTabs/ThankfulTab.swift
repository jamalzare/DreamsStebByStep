//
//  ThankfulTab.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/8/21.
//

import Foundation
import SwiftUI

struct ThankfulTab: View {
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(
        entity: Thankful.entity(),
        sortDescriptors: [
             NSSortDescriptor(keyPath: \Thankful.order, ascending: false)
        ]
        
    ) var thanks: FetchedResults<Thankful>
    
    
    @State private var showAddView = false
    @State private var selectedThank: Thankful?
    
    private var helpText = "What do you grateful or thnakful for? What do you appreciate in you life and why? in this tab TAP On Plus Button (+) and in the form that will apear type the things that you thankful for and describe the why you thank ful for and then select a color for beautify it then submit it."
    
    var body: some View {
        
        VStack(spacing:0) {
            
            titleView(title: "I am Thankful for: \(thanks.count) ")
            
            DynamicList {
                
                ForEach(thanks, id:\.self){ thank in
                    Button(action: {
                        self.selectedThank = thank
                        self.showAddView.toggle()
                    }){
                        CardView(text: "\(thank.text!)", color: Color(hexString: thank.color!).opacity(0.20))
                    }
                }
                HelpView(text: helpText){}
                
            }
            AddButton{
                self.selectedThank = nil
                self.showAddView = true
            }
        }
        .sheet(isPresented: $showAddView){
            AddThankfulView(thank: self.selectedThank)
                .environment(\.managedObjectContext, self.moc)
        }
        
    }
}
