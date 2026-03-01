//
//  ContentView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI



struct KnittingView: View {
    var viewModel: ProjectViewModel
    var currentPosition: (partIndex: Int, rowNumber: Int) {
        viewModel.currentPosition ?? (0, 0)
    }
    var currentRow: Row { viewModel.currentRow ?? Row(instructions: "This row does not exist.")}
    var body: some View {
        if !viewModel.isFinished {
            VStack {
                Text("🧶 Knit!!!").font(.largeTitle)
                Text("You are at the row \(currentPosition.rowNumber+1)")
                HStack{
                    Text("Follow this pattern: ")
                }
                RowView(row: currentRow)
                HStack {
                    Button("Unravel"){
                        viewModel.unravel()
                    }
                    Button("Next Row"){
                        viewModel.knitRow()
                    }
                }
            }
            .padding()
        }
        else {
            Text("Congratulations! You've completed this project part!")
        }
        Button("Go back to project") {
            if viewModel.saveProject() {
                viewModel.updateCurrentProjectPart()
                viewModel.currentPosition = nil
            }
        }
        }
}

#Preview {
    ProjectView()
}
