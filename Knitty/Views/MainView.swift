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
    @State private var renamingEntry: ProjectIndexEntry?
    @State private var renameText = ""

    private var isRenameValid: Bool {
        guard let entry = renamingEntry else { return false }
        let trimmed = renameText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return false }
        return !store.entries.contains { $0.id != entry.id && $0.name == renameText }
    }

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
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            try? store.deleteProject(id: entry.id)
                        }
                        Button("Rename") {
                            renamingEntry = entry
                            renameText = entry.name
                        }
                        .tint(.blue)
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
            .alert(
                "Rename project",
                isPresented: Binding(
                    get: { renamingEntry != nil },
                    set: { if !$0 { renamingEntry = nil } }
                )
            ) {
                TextField("Name", text: $renameText)
                Button("Save") {
                    if let entry = renamingEntry {
                        try? store.renameProject(id: entry.id, to: renameText)
                    }
                    renamingEntry = nil
                }
                .disabled(!isRenameValid)
                Button("Cancel", role: .cancel) { renamingEntry = nil }
            }
        }
    }
}

#Preview {
    MainView()
        .environment(ProjectStore())
}
