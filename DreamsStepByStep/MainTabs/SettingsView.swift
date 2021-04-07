//
//  SettingsView.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/7/21.
//

import Foundation
import SwiftUI

struct SettingView: View {
    
    @EnvironmentObject var setting: AppSetting
    let color = Color.black.opacity(0.1)
    
    var body: some View {
        VStack{
            HStack{ Spacer() }
            Spacer()
            AppText("Change Text Size:", fontSize: 19)
                .padding()
                .background(lightBlack)
                .cornerRadius(26)
            
            HStack{
                
                IconButton(icon: "plus", fontSize: 19, background: .white, shadow: 1){
                    if self.setting.fontSize < 61 {
                        self.setting.fontSize += 1
                    }
                }
                AppText("\(Int(setting.fontSize))", fontSize: setting.fontSize)
                
                IconButton(icon: "minus", fontSize: 19, background: .white, shadow: 1){
                    if self.setting.fontSize > 8{
                        self.setting.fontSize -= 1
                    }
                }
                
            }
            
        }.padding()
            .background(color)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView().environmentObject(AppSetting())
    }
}
