//
//  ContentView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI



struct KnittingView: View {
    var viewModel: ProjectViewModel
    var rowNumber: Int { viewModel.currentRowNumber ?? 0}
    var currentRow: Row { viewModel.currentRow ?? Row(instructions: "This row does not exist.")}
//    var isFinishedProjectPart: Bool {viewModel.isFinishedProjectPart}
    var body: some View {
        if true{
            VStack {
                Text("🧶 Knit!!!").font(.largeTitle)
//                Text("You are at the row \(rowNumber+1)")
                HStack{
                    Text("Follow this pattern: ")
                }
                RowView(row: currentRow)
                HStack {
//                    Button("-1"){
//                        viewModel.unravel()
//                    }
                    Button("Next Row"){
                        viewModel.knitRow()
                    }
                }
//                
//                HStack {
//                      Button("-1") {
//                          rowNumber -= 1
//                          if rowNumber < 0{
//                              rowNumber = 0
//                          }
//                          UserDefaults.standard.set(rowNumber, forKey: "rowNumber")
//                      }
//                                                            
//                      Button("+1") {
//                          rowNumber += 1
//                          UserDefaults.standard.set(rowNumber, forKey: "rowNumber")
//                      }
//                  }
            }
            .padding()
        }
        else {
            Text("Congratulations!")
            /*
            Button("Start again"){
                rowNumber = 0
            }*/
        }
        }
        
}

//#Preview {
//    ProjectView()
//}
