//
//  MainView.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.03.26.
//

import SwiftUI

struct MainView: View {
    @Environment(ProjectStore.self) private var store
    @State private var openedProject: Project?
    
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
            InlineNameEntry(
                buttonLabel: "Add new project",
                placeholder: "Project name",
                defaultName: "New project",
                existingNames: store.entries.map(\.name),
                onSubmit: { name in
                    let newProject = store.createProject(name: name)
                    try? store.saveProject(newProject)
                    openedProject = newProject
                }
            )
            .navigationDestination(item: $openedProject) {
                project in ProjectView(projectID: project.id, store: store)
            }
        }
    }
}

#Preview {
    MainView()
        .environment(ProjectStore())
}
