//
//  MainView.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.03.26.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Project.name) private var projects: [Project]
    @State private var openedProject: Project?
    @State private var renamingProject: Project?
    @State private var renameText = ""

    private var isRenameValid: Bool {
        guard let project = renamingProject else { return false }
        let trimmed = renameText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return false }
        return !projects.contains { $0 !== project && $0.name == renameText }
    }

    var body: some View {
        NavigationStack {
            if projects.isEmpty {
                Text("No saved projects yet.")
                    .navigationTitle("Knitty")
            } else {
                List(projects) { project in
                    NavigationLink(project.name) {
                        ProjectView(project: project)
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            context.delete(project)
                            try? context.save()
                        }
                        Button("Rename") {
                            renamingProject = project
                            renameText = project.name
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
                existingNames: projects.map(\.name),
                onSubmit: { name in
                    let newProject = Project(name: name, projectParts: [])
                    context.insert(newProject)
                    try? context.save()
                    openedProject = newProject
                }
            )
            .navigationDestination(item: $openedProject) {
                project in ProjectView(project: project)
            }
            .alert(
                "Rename project",
                isPresented: Binding(
                    get: { renamingProject != nil },
                    set: { if !$0 { renamingProject = nil } }
                )
            ) {
                TextField("Name", text: $renameText)
                Button("Save") {
                    renamingProject?.name = renameText
                    try? context.save()
                    renamingProject = nil
                }
                .disabled(!isRenameValid)
                Button("Cancel", role: .cancel) { renamingProject = nil }
            }
        }
    }
}

#Preview {
    MainView()
        .modelContainer(PreviewSupport.container)
}
