//
//  MP_Soap_NamesApp.swift
//  MP_Soap_Names
//
//  Created by Hari Dass Khalsa on 5/4/26.
//

import SwiftUI
import SwiftData
import SQLite3

private func checkpointWAL(at url: URL) {
    var db: OpaquePointer?
    guard sqlite3_open_v2(url.path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK else {
        print("Checkpoint: failed to open \(url.path)")
        return
    }
    defer { sqlite3_close(db) }
    if sqlite3_exec(db, "PRAGMA wal_checkpoint(TRUNCATE);", nil, nil, nil) != SQLITE_OK {
        print("Checkpoint: failed — \(String(cString: sqlite3_errmsg(db)))")
    }
}

@main
struct MP_Soap_NamesApp: App {
    private let storeURL: URL

    init() {
        let schema = Schema([Item.self, Name.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        self.storeURL = modelConfiguration.url
    }

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
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
                    try? sharedModelContainer.mainContext.save()
                    checkpointWAL(at: storeURL)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
