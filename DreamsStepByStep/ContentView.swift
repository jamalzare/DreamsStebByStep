//
//  ContentView.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/4/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var page = 0
    
    var body: some View {
        NavigationView{
            VStack {
                PagerView(pageCount: 4, currentIndex: $page) {
                    TargetsTab()
                    TipsTap()
                    Color.green
                    Color.blue
                }
                
                MainTabBar(page: $page)
            }
            
        }
    }
}

struct MainTabBar : View {
    @Binding var page: Int
    
    var body: some View {
        HStack{
            
            Spacer()
            MainTabBarItem(currentIndex: $page, imageName: "moon.stars.fill", index: 0)
            MainTabBarItem(currentIndex: $page, imageName: "pin.fill", index: 1)
            MainTabBarItem(currentIndex: $page, imageName: "lightbulb.fill", index: 2)
            MainTabBarItem(currentIndex: $page, imageName: "bell.fill", index: 3)
            Spacer()
        }
        .padding(.bottom, 4)
        .background(Color.white)
    }
}


struct MainTabBarItem : View {
    
    @Binding var currentIndex: Int
    
    var imageName: String
    var index: Int = 0
    
    var selected: Bool{
        return index == currentIndex
    }
    
    var body: some View {
        
        Button(action: {
            self.currentIndex = self.index
        }) {
            Image(systemName: imageName)
                .foregroundColor(Color.black.opacity(selected ? 0.5: 0.3))
                .padding()
                .background(selected ? Color.white: lightBlack)
                .background(Color.white)
                .font(Font.system(size: selected ? 25: 15))
                .clipShape(Circle())
                .shadow(radius: selected ? 1: 0)
                .padding(.horizontal, selected ? 25: 5)
        }
        .animation(.spring())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
