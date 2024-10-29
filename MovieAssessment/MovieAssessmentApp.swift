//
//  MovieAssessmentApp.swift
//  MovieAssessment
//
//  Created by Xavier Toh on 29/10/24.
//

import SwiftUI

@main
struct MovieAssessmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
