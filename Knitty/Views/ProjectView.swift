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
    @State var viewModel: ProjectViewModel = ProjectViewModel()
    var body: some View {
        if viewModel.projectPartIndex != nil {
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
