//
//  WeatherDemoApp.swift
//  WeatherDemo
//
//  Created by Michael Leoniy on 12/16/24.
//

import SwiftUI

@main
struct WeatherDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
