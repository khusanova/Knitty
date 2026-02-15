//
//  ProjectView.swift
//  Knitty
//
//  Created by Y. Khusanova on 15.02.26.
//

import SwiftUI

/// When user opens a project for the first time they see this view and chose a project part.
struct ProjectView: View {
    var viewModel: ProjectViewModel = ProjectViewModel()
    var body: some View {
        if let projectPartIndex = viewModel.projectPartIndex {
            KnittingView(viewModel: viewModel)
        }
        else{
            VStack{
                ForEach(Array(viewModel.getProjectPartNames().enumerated()), id: \.offset) { index, name in
                    Button("\(name)"){
                        viewModel.startKnitting(projectPartIndex: index)
                    }
                }
            }
        }
    }
}

#Preview {
    ProjectView()
}
