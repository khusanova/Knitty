//
//  ContentView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI



struct KnittingView: View {
    var viewModel: KnittingViewModel
    var currentRow: Row { viewModel.currentRow ?? Row(instructions: "This row does not exist.")}
    var body: some View {
        Group {
            if !viewModel.isFinished {
                VStack {
                    Text("🧶 Knit!!!").font(.largeTitle)
                    Text("You are at the row \(viewModel.rowCounter+1)")
                    HStack{
                        Text("Follow this pattern: ")
                    }
                    RowView(row: currentRow)
                    HStack {
                        if viewModel.displayUnravelButton {
                            Button("Unravel"){
                                viewModel.unravel()
                            }
                        }
                        if viewModel.displayKnitButton {
                            Button("Next Row"){
                                viewModel.knitRow()
                            }
                        }
                    }
                }
                .padding()
            }
            else {
                Text("Congratulations! You've completed this project part!")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("Edit project part") {
                    EditorView(viewModel: viewModel.projectVM, partIndex: viewModel.partIndex)
                }
            }
        }
        .alert(
            "Something went wrong",
            isPresented: Binding(get: {viewModel.errorMessage != nil}, set: {if !$0 { viewModel.errorMessage = nil }}),
            presenting: viewModel.errorMessage
        ) {
            _ in Button("OK", role: .cancel) {}
        } message: {
            msg in Text(msg)
        }
    }
}

#Preview {
    ProjectView(store: ProjectStore())
}
