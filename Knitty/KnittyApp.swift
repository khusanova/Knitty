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
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: Project.self)
    }
}
