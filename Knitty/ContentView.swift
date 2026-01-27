//
//  ContentView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI



struct ContentView: View {
    @State private var rowNumber = 119
    @State private var currentPattern = Pattern.bananaSockLeft
    var currentRow: Row { currentPattern.rows[ rowNumber]}
    var body: some View {
        if rowNumber < currentPattern.count{
            VStack {
                Text("🧶 Knit!!!").font(.largeTitle)
                Text("You are at the row \(rowNumber)")
                HStack{
                    Text("Follow this pattern: \(currentPattern.count)")
                }
                
                RowView(row: currentRow)
                HStack {
                      Button("-1") {
                          rowNumber -= 1
                      }
                                                            
                      Button("+1") {
                          rowNumber += 1
                      }
                  }
            }
            .padding()
        }
        else if rowNumber == currentPattern.count{
            Text("Congratulations!")
            Button("Start again"){
                rowNumber = 0
            }
        }
        }
        
}

#Preview {
    ContentView()
}
