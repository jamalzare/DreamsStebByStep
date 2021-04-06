//
//  File.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/6/21.
//

import Foundation
import SwiftUI

extension Color{
    
    //MD: Material Design

    static let redMDString = "F44336"
    
    static let redMD: Color = {
        Color(hexString: redMDString)
    }()
    
    static let pinkMDString = "E91E63"
    static let pinkMD: Color = {
        Color(hexString: pinkMDString)
    }()
    
    static let purpleMDString = "9C27B0"
    static let purpleMD: Color = {
        Color(hexString: purpleMDString)
    }()
    
    static let deepPurpleMDString = "673AB7"
    static let deepPurpleMD: Color = {
        Color(hexString: deepPurpleMDString)
    }()
    
    static let indigoMDString = "3F51B5"
    static let indigoMD: Color = {
        Color(hexString: indigoMDString)
    }()
    
    static let blueMDString = "2196F3"
    static let blueMD: Color = {
        Color(hexString: blueMDString)
    }()
    
    static let lightBlueMDString = "03A9F4"
    static let lightBlueMD: Color = {
        Color(hexString: lightBlueMDString)
    }()
    
    static let cyanMDDString = "00BCD4"
    static let cyanMD: Color = {
        Color(hexString: cyanMDDString)
    }()
    
    static let tealMDString = "009688"
    static let tealMD: Color = {
        Color(hexString: tealMDString)
    }()
    
    static let greenMDString = "4CAF50"
    static let greenMD: Color = {
        Color(hexString: greenMDString)
    }()
    
    static let lightGreenMDString = "8BC34A"
    static let lightGreenMD: Color = {
        Color(hexString: lightGreenMDString)
    }()
    
    static let limeMDString = "CDDC39"
    static let limeMD: Color = {
        Color(hexString: limeMDString)
    }()
    
    static let yellowMDString = "FFEB3B"
    static let yellowMD: Color = {
        Color(hexString: yellowMDString)
    }()
    
    static let amberMDString = "FFC107"
    static let amberMD: Color = {
        Color(hexString: amberMDString)
    }()
    
    static let orangeMDString = "FF9800"
    static let orangeMD: Color = {
        Color(hexString: orangeMDString)
    }()
    
    static let deepOrangeMDString = "FF5722"
    static let deepOrangeMD: Color = {
        Color(hexString: deepOrangeMDString)
    }()
    
    static let brownMDString = "795548"
    static let brownMD: Color = {
        Color(hexString: brownMDString)
    }()
    
    static let grayMDString = "9E9E9E"
    static let grayMD: Color = {
        Color(hexString: grayMDString)
    }()
    
    static let blueGrayMDString = "607D8B"
    static let blueGrayMD: Color = {
        Color(hexString: blueGrayMDString)
    }()
    
    
    static let colors: [Color] = {
        return[
            redMD, pinkMD, purpleMD, deepPurpleMD, indigoMD,
            blueMD, lightBlueMD, cyanMD, tealMD, blueGrayMD,
            greenMD, lightGreenMD, limeMD, yellowMD,
            amberMD, orangeMD, deepOrangeMD, brownMD, grayMD,
        ]
    }()
    
    
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static func rgba(_ red: Double, _ green: Double, _ blue: Double, opacity: Double = 1)-> Color {
       // return Color(red: red/255, green: green/255, blue: blue/255)
        
        return self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue:  Double(blue) / 255,
            opacity: Double(opacity)
        )
    }
}
