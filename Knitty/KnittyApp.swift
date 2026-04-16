//
//  KnittyApp.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI

@main
struct KnittyApp: App {
    @State private var store = ProjectStore()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(store)
        }
    }
}
