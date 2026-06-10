//
//  KnittyApp.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI
import SwiftData

@main
struct KnittyApp: App {
    private let container: ModelContainer
    @State private var store: ProjectStore

    init() {
        do {
            let container = try ModelContainer(for: Project.self)
            self.container = container
            _store = State(initialValue: ProjectStore(context: container.mainContext))
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(store)
        }
        .modelContainer(container)
    }
}
