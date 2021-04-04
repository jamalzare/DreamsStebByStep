//
//  PagerView.swift
//  TargetsStepByStep
//
//  Created by Jamal on 3/21/20.
//  Copyright © 2020 Jamal. All rights reserved.
//

import SwiftUI

struct Cv: View {
    @State private var currentPage = 0

    var body: some View {
        
        VStack{
            Button(action: {
                self.currentPage = 2
            }){
                Text("Tap heere")
            }
            
        PagerView(pageCount: 4, currentIndex: $currentPage) {
            Color.blue
            Color.red
            
            HStack{
              Text("something")
            }
            
            Color.green
            
        }
            
        }
        
    }
}

struct PagerView<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content

    @GestureState private var translation: CGFloat = 0

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                self.content.frame(width: geometry.size.width)
            }.background(Color.white)
            .frame(width: geometry.size.width, alignment: .leading)
            .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
            .offset(x: self.translation)
            .animation(.spring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.width
                }.onEnded { value in
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                    self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                }
            )
        }
    }
}

struct PagerView_Previews: PreviewProvider {
    static var previews: some View {
        Cv()
    }
}
