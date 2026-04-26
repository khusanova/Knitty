//
//  ProjectView.swift
//  Knitty
//
//  Created by Y. Khusanova on 15.02.26.
//

import SwiftUI

/// When user opens a project for the first time they see this view and chose a project part.
/// if user already works on the project, then the last project part user worked on is displayed as knitting view
struct ProjectView: View {
    @State var viewModel: ProjectViewModel
    @State private var renamingPartIndex: Int?
    @State private var renameText = ""

    init(projectID: UUID? = nil, store: ProjectStore) {
        self._viewModel = State(initialValue: ProjectViewModel(projectID: projectID, store: store))
    }

    private var isRenameValid: Bool {
        guard let index = renamingPartIndex else { return false }
        let trimmed = renameText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return false }
        return !viewModel.getProjectPartNames().enumerated().contains {
            $0.offset != index && $0.element == renameText
        }
    }

    var body: some View {
        VStack {
            List(Array(viewModel.getProjectPartNames().enumerated()), id: \.offset) { index, name in
                NavigationLink(name) {
                    KnittingView(viewModel: viewModel.makeKnittingViewModel(partIndex: index))
                }
                .swipeActions {
                    Button("Rename") {
                        renamingPartIndex = index
                        renameText = name
                    }
                    .tint(.blue)
                }
            }
            .navigationTitle("Project parts")
            InlineNameEntry(
                buttonLabel: "Add project part",
                placeholder: "Part name",
                defaultName: "New project part",
                existingNames: viewModel.getProjectPartNames(),
                onSubmit: { viewModel.addProjectPart(name: $0) }
            )
        }
        .alert(
            "Rename part",
            isPresented: Binding(
                get: { renamingPartIndex != nil },
                set: { if !$0 { renamingPartIndex = nil } }
            )
        ) {
            TextField("Name", text: $renameText)
            Button("Save") {
                if let index = renamingPartIndex {
                    viewModel.renameProjectPart(at: index, to: renameText)
                }
                renamingPartIndex = nil
            }
            .disabled(!isRenameValid)
            Button("Cancel", role: .cancel) { renamingPartIndex = nil }
        }
    }
}

#Preview {
    ProjectView(store: ProjectStore())
}
