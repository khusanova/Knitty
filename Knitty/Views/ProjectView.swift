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
    @State var isAddingPart = false
    @State var showNameValidationRules = false
    @State var newPartName = "New project part"
    @FocusState private var isTextFieldFocused: Bool

    init(projectName: String? = nil) {
        self._viewModel = State(initialValue: ProjectViewModel(projectName: projectName))
    }

    var isValidName: Bool {
        !newPartName.trimmingCharacters(in: .whitespaces).isEmpty && !viewModel.getProjectPartNames().contains(newPartName)
    }

    var body: some View {
        VStack {
            List(Array(viewModel.getProjectPartNames().enumerated()), id: \.offset) { index, name in
                NavigationLink(name) {
                    KnittingView(viewModel: viewModel.makeKnittingViewModel(partIndex: index))
                }
            }
            .navigationTitle("Project parts")
            Button("Add project part") {
                isAddingPart = true
                isTextFieldFocused = true
            }
            if isAddingPart {
                TextField("Part name", text: $newPartName)
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        guard isValidName else {
                            showNameValidationRules = true
                            if viewModel.getProjectPartNames().contains(newPartName) {
                                newPartName += " (2)"
                                isTextFieldFocused = true
                            }
                            return
                        }
                        viewModel.addProjectPart(name: newPartName)
                        isAddingPart = false
                        newPartName = "New project part"
                    }
                if showNameValidationRules {
                    Text("Name must be unique and non-empty.")
                }
            }
        }
    }
}

#Preview {
    ProjectView()
}
