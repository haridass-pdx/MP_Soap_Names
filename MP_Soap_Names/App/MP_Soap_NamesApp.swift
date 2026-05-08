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
        let storeURL = modelConfiguration.url
        print(storeURL)
        if !FileManager.default.fileExists(atPath: storeURL.path),
           let bundledURL = Bundle.main.url(forResource: "default", withExtension: "store") {
            try? FileManager.default.copyItem(at: bundledURL, to: storeURL)
        }

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
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
            CheckLoginView()
        }
        .modelContainer(sharedModelContainer)
    }
}
