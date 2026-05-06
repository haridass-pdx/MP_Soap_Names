//
//  MP_Soap_NamesApp.swift
//  MP_Soap_Names
//
//  Created by Hari Dass Khalsa on 5/4/26.
//

import SwiftUI
import SwiftData

@main
struct MP_Soap_NamesApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Name.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
            print(URL.applicationSupportDirectory.path(percentEncoded: false))

        } catch {
            // Schema changed during development — delete the old store and retry
            let storeURL = modelConfiguration.url
            let related = [
                storeURL,
                storeURL.deletingPathExtension().appendingPathExtension("store-shm"),
                storeURL.deletingPathExtension().appendingPathExtension("store-wal"),
            ]
            for file in related {
                try? FileManager.default.removeItem(at: file)
            }
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
