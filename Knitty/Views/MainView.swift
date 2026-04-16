//
//  MainView.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.03.26.
//

import SwiftUI

struct MainView: View {
    @Environment(ProjectStore.self) private var store

    var body: some View {
        NavigationStack {
            if store.entries.isEmpty {
                Text("No saved projects yet.")
                    .navigationTitle("Knitty")
            } else {
                List(store.entries) { entry in
                    NavigationLink(entry.name) {
                        ProjectView(projectID: entry.id, store: store)
                    }
                }
                .navigationTitle("Knitty")
            }
        }
    }
}

#Preview {
    MainView()
        .environment(ProjectStore())
}
