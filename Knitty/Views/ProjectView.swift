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
        //KnittingView(viewModel: viewModel)
        VStack{
            ForEach(viewModel.getProjectPartNames(), id: \.self) {
                Text("\($0)")
            }
        }
    }
}

#Preview {
    ProjectView()
}
