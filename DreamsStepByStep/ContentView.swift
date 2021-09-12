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
    @State private var offset: CGFloat = -1000
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0){
                    ZStack{
                        PagerView(pageCount: 6, currentIndex: $page) {
                            TargetsTab()
                            TipsTap()
                            ThankfulTab()
                            TodayTab()
                            DesiresTab()
                            GuidesTab()
                        }
                        
                        SettingView().offset(x: offset)
                            .animation(.spring())
                        
                        VStack(spacing: 0){
                            SettingButton(action: {
                                self.offset = self.offset == 0 ? -1000: 0
                            })
                            Spacer()
                        }
                    }
                    MainTabBar(page: $page)
                    
                }
                
                
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
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
            MainTabBarItem(currentIndex: $page, imageName: "face.dashed.fill", index: 2)
            MainTabBarItem(currentIndex: $page, imageName: "sun.max.fill", index: 3)
            MainTabBarItem(currentIndex: $page, imageName: "heart.fill", index: 4)
            MainTabBarItem(currentIndex: $page, imageName: "lightbulb.fill", index: 5)
            
            Spacer()
        }
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.1))
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
                .font(Font.system(size: selected ? 22: 15))
                .clipShape(Circle())
                .shadow(radius: selected ? 1: 0)
                .padding(.horizontal, selected ? 5: 0)
        }
        .animation(.spring())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SettingButton: View {
    var action: () -> Void
    var body: some View {
        HStack{
            Spacer()
            Button(action: action){
                Image(systemName: "gear")
                    .padding(10)
                    .background(Color.white)
                    .foregroundColor(Color.black.opacity(0.5))
                    .font(Font.system(size: 25, weight: .heavy))
                    .clipShape(Circle())
                    .shadow(radius: 1)
            }
        }
    }
}
