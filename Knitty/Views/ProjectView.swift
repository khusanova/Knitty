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

    init(projectID: UUID? = nil, store: ProjectStore) {
        self._viewModel = State(initialValue: ProjectViewModel(projectID: projectID, store: store))
    }

    var body: some View {
        VStack {
            List(Array(viewModel.getProjectPartNames().enumerated()), id: \.offset) { index, name in
                NavigationLink(name) {
                    KnittingView(viewModel: viewModel.makeKnittingViewModel(partIndex: index))
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
    }
}

#Preview {
    ProjectView(store: ProjectStore())
}
