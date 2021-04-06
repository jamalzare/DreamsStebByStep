//
//  Global.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/4/21.
//

import Foundation
import SwiftUI



class AppSetting: ObservableObject {
    @Published var fontSize: CGFloat = 15
    
    static var titleFontSize: CGFloat{
        return 15
    }
}

var lightBlack = Color.black.opacity(0.05)

var blackText = Color.black.opacity(0.5)

func randomCGFloat(_ lowerLimit: CGFloat, _ upperLimit: CGFloat)-> CGFloat{
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upperLimit - lowerLimit) + lowerLimit
}

func randomCGFloat(_ upperLimit: CGFloat)-> CGFloat{
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upperLimit)
}

func randomInt(_ upperLimit: Int)-> Int{
    return Int(randomCGFloat(CGFloat(upperLimit)))
}

func randomInt(_ lowerLimit: Int, _ upperLimit: Int)-> Int{
    return Int(randomCGFloat(CGFloat(lowerLimit), CGFloat(upperLimit)))
}

func randomColor()-> Color {
    let i = randomInt(Color.colors.count - 1)
    return Color.colors[i]
}

func getOpaqueColor(_ color: String) -> Color {
    return Color(hexString: color).opacity(0.2)
}
extension Binding where Value == String {
    func getFrom(_ value : String?) -> Binding<String> {
        return Binding<String>(get: {
            return value ?? ""
        }) { value in
            self.wrappedValue = value
        }
    }
}

extension Binding where Value == Int {
    func getFrom(_ value : Int?) -> Binding<Int> {
        return Binding<Int>(get: {
            return value ?? 0
        }) { value in
            self.wrappedValue = value
        }
    }
}


struct Global: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello World!"/*@END_MENU_TOKEN@*/)
    }
}

struct Global_Previews: PreviewProvider {
    static var previews: some View {
        Global()
    }
}


struct AppText: View {
    
    private var fontSize: CGFloat = 15
    private var text = ""
    private var foregroundColor = blackText
    
    init(_ text: String, fontSize: CGFloat = 15, foregroundColor: Color = blackText) {
        self.text = text
        self.fontSize = fontSize
        self.foregroundColor = foregroundColor
    }
    var body: some View {
        Text(text)
            .font(Font.system(size: fontSize, weight: .heavy))
            .foregroundColor(blackText)
    }
}


struct titleView: View {
    var title: String
    
    var body: some View {
        HStack{
            Text(title).bold()
                .fontWeight(.heavy)
                .font(Font.system(size: AppSetting.titleFontSize))
                .foregroundColor(blackText)
                .lineLimit(1)
                .padding(10)
                .background(Color.black.opacity(0.07))
                .clipShape(Capsule())
                .padding(.horizontal)
            Spacer()
        }
        .background(Color.white)
    }
}


struct IconButton: View {
    let icon: String
    var fontSize: CGFloat = 19
    var background = lightBlack
    var shadow: CGFloat = 0
    var action: ()-> Void
    
    var body: some View {
        
        Button(action: {
            self.action()
        }){
            Image(systemName: icon)
                .padding()
                .background(background)
                .foregroundColor(Color.black.opacity(0.5))
                .font(Font.system(size: fontSize, weight: .heavy))
                .clipShape(Circle())
                .shadow(radius: shadow)
        }
    }
}

struct TargetDetailHeader: View {
    var title: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        HStack {
            IconButton(icon: "arrow.left"){
                self.presentationMode.wrappedValue.dismiss()
            }.padding(.horizontal)
            titleView(title: title)
        }
        .background(Color.white)
    }
}

//struct Header: View {
//    var title: String
// //   @Binding var donate: Donate
//    @Binding var presentMode: Bool
//    
//    var body: some View {
//        HStack{
//            titleView(title: title)
//            
//            if donate.active{
//                
//                Button(action: {
//                    self.presentMode.toggle()
//                }){
//                    
//                    Text(donate.buttonTitle)
//                        .fontWeight(.heavy)
//                //        .font(Font.system(size: 20))
//                        .foregroundColor(Color.green.opacity(0.5))
//                        .padding(8)
//                        .background(Color.white)
//                        .clipShape(Capsule())
//                        .shadow(radius: 1)
//                        .padding(.horizontal)
//                    
//                }
//            }
//            
//        }
//        .background(Color.white)
//        
//    }
//}

struct CardView: View {
    @EnvironmentObject var setting: AppSetting
    var text: String
    var color: Color = lightBlack
    var metaText = ""
    
    var body: some View {
        (Text(text) + Text(metaText).foregroundColor(Color.yellow))
            .fontWeight(.heavy)
            .font(Font.system(size: setting.fontSize))
            .foregroundColor(Color.black.opacity(0.5))
            .lineLimit(300)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(color)
            .cornerRadius(40)
    }
}

struct TitleCardView: View {
    var title: String
    var text: String
    var color: Color
    @EnvironmentObject var setting: AppSetting
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(title)
                    .fontWeight(.heavy)
                    .font(Font.system(size: setting.fontSize + 2))
                    .foregroundColor(Color.black.opacity(0.6))
                    .bold()
                
                Spacer()
            }
            
            Text(text)
                .fontWeight(.heavy)
                .font(Font.system(size: setting.fontSize))
                .foregroundColor(Color.black.opacity(0.5))
                .lineLimit(200)
        }
        .padding()
        .background(color)
        .cornerRadius(40)
        .shadow(radius: color == .white ? 1: 0)
        
    }
}
struct CircleButton: View {
    var icon: String
    var action = {}
    var body: some View {
        HStack{
            Spacer()
            
            Image(systemName: icon)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .foregroundColor(blackText)
                .font(Font.system(size: 23).weight(.heavy))
                .clipShape(Circle())
                .shadow(radius: 1)
                .padding(.trailing)
                .padding(.bottom, 80)
                .onTapGesture {
                    self.action()
            }
            
            
        }
        .frame(height: 0)
        .background(Color.gray)
    }
}


struct AddButton: View {
    
    var action = {}
    var body: some View {
        CircleButton(icon:  "plus", action: action)
    }
}

struct RefreshButton: View {
    
    var action = {}
    var body: some View {
        CircleButton(icon:  "arrow.2.circlepath", action: action)
    }
}



struct HelpView: View {
    var text: String
    var action = {}
    
    var body: some View {
        CardView(text: text)
            .overlay(RoundedRectangle(cornerRadius: 40)
                .stroke(Color.black.opacity(0.2), lineWidth: 0.0))
            .padding(.bottom, 55)
            .onTapGesture { self.action() }
    }
}

struct AppLabel: View {
    var title: String
    
    var body: some View {
        HStack{
            Text(title)
                .font(Font.system(size: 14, weight: .heavy))
                .foregroundColor(Color.black.opacity(0.6))
                .padding(10)
                .background(lightBlack)
                .cornerRadius(26)
                .lineLimit(1)
            
            Spacer()
        }
    }
}

struct AppSubLabel: View {
    var title: String
    
    var body: some View {
        HStack{
            Text(title)
                .font(Font.system(size: 15, weight: .heavy))
                .foregroundColor(Color.black.opacity(0.5))
                .lineLimit(10)
                .padding(10)
                .background(lightBlack)
                .cornerRadius(26)
            
            Spacer()
        }
    }
}

struct AppButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        
        Text(title)
            .fontWeight(.heavy)
            .font(Font.system(size: 15))
            .foregroundColor(blackText)
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(radius: 1)
            
            .onTapGesture {
                self.action()
        }
        
    }
}

struct SubmitButton: View {
    var action: () -> Void
    var body: some View {
        AppButton(title: "Save", action: action)
    }
}

struct DeleteButton: View {
    var action: () -> Void
    var body: some View {
        AppButton(title: "Delete", action: action)
    }
}

struct CancelButton: View {
    var action: () -> Void
    var body: some View {
        AppButton(title: "Cancel", action: action)
    }
}


struct AppTextField: View {
    var label: String
    @Binding var text: String
    var placeHolder: String = "Type Here"
    var textAlignment:TextAlignment = .center
    
    var body: some View {
        VStack{
            AppLabel(title: label)
            
            TextField(placeHolder, text: $text)
                
                .multilineTextAlignment(textAlignment)
                .font(Font.system(size: 15, weight: .heavy))
                .foregroundColor(Color.black.opacity(0.5))
                .padding(10)
                .overlay(Capsule().stroke(Color.black.opacity(0.1), lineWidth: 1))
        }
    }
}



struct ColorsView: View {
    @Binding var color: String
    private let colors = DefinedColors.colors
    
    var body: some View {
        
        VStack{
            AppLabel(title: "Select a color:")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(colors, id:\.self) { clr in
                        Text("")
                            
                            .padding(12)
                            .padding(.horizontal, self.color == clr ? 20: 14)
                            .background(Color(hexString: clr).opacity(0.5))
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.black, radius: self.color == clr ? 1: 0)
                            
                            .onTapGesture {
                                withAnimation(.spring()){
                                    self.select(color: clr)
                                }
                        }
                    }
                }.padding(4)
            }
        }
    }
    
    func select(color: String){
        self.color = color
    }
}


struct AppTabButton: View {
    
    var title: String
    @Binding var currentTab: Int
    @State var index: Int
    @Binding var count: Int
    
    var selected: Bool{
        return currentTab == index
    }
    
    var body: some View {
        
        Text(title + (selected ? ": \(count)": ""))
            .fontWeight(.heavy)
            .animation(.interactiveSpring())
            .font(Font.system(size: selected ? 16 : 10))
            .foregroundColor(Color.black.opacity(0.5))
            .padding(.horizontal, selected ? 15: 4)
            .padding(6)
            .background(selected ? Color.white: Color.black.opacity(0.05))
            .clipShape(Capsule())
            .shadow(radius: selected ? 1:0)
            .animation(.spring())
            .padding(.bottom, 4)
            .onTapGesture {
                self.currentTab = self.index
        }
    }
}








struct AppJustForSpacing: View {
    var body: some View {
        Rectangle().frame(height: 0.5)
            .foregroundColor(Color.white)
    }
}


