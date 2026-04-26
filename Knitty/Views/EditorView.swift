//
//  EditorView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI

struct EditorView: View {
    var viewModel: ProjectViewModel
    let partIndex: Int

    var body: some View {
        Text("Editing \(viewModel.project.projectParts[partIndex].name)")
            .navigationTitle("Edit part")
    }
}

#Preview {
    NavigationStack {
        EditorView(viewModel: ProjectViewModel(store: ProjectStore()), partIndex: 0)
    }
}
