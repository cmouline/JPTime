//
//  JPTTimeApp.swift
//  JPTTime
//
//  Created by Moulinet Chloë on 07/02/2025.
//

import SwiftUI
import SwiftData

@main
struct JPTTimeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            DaySchedule.self,
            Account.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            EntriesListView()
        }
        .modelContainer(sharedModelContainer)
    }
}
