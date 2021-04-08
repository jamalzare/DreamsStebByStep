//
//  DynamicList.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/8/21.
//

import Foundation
import SwiftUI

struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct DynamicList<Content: View>: View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        
        if #available(iOS 14.0, *) {
            ScrollView {
                LazyVStack {
                    self.content()
                }.padding()
                .buttonStyle(NoButtonStyle())
            }
        }
        
        else {
            
            List {
                self.content()
            }
            .listStyle(PlainListStyle())
            .buttonStyle(NoButtonStyle())
            
            .onAppear {
                UITableView.appearance().tableFooterView = UIView()
                UITableView.appearance().separatorColor = .clear
                UITableView.appearance().separatorStyle = .none
            }
        }
    }
}

