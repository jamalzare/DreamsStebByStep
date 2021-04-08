//
//  DreamsStepByStepApp.swift
//  DreamsStepByStep
//
//  Created by Jamal on 4/4/21.
//

import SwiftUI

@main
struct DreamsStepByStepApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup  {
            
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(AppSetting())
        }
    }
}
