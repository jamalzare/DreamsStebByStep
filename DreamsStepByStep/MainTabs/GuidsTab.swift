//
//  GuidsTab.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/7/21.
//

import Foundation
import SwiftUI

struct GuidesTab: View {
    
    private var guides = Guide.guides
    
    @State private var showAddView = false
    
    var body: some View {
        
        VStack(spacing:0) {
            
            titleView(title: "Guidance")
            
            DynamicList {
                ForEach(guides){ guide in
                    TitleCardView(title: guide.title, text: guide.content[0].text, color: lightBlack)
                }
            }
            AppJustForSpacing()
        }
    }
}


struct Tab3View_Previews: PreviewProvider {
    static var previews: some View {
        GuidesTab()
    }
}
