//
//  aezakmiApp.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import SwiftUI

@main
struct aezakmiApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
