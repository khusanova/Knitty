//
//  ContentView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI

struct ContentView: View {
    @State private var rowNumber = 110
    @State private var currentPattern = Pattern.bananaSock
    var currentRow: [RowElement] { currentPattern.displayRow(at: rowNumber)}
    var body: some View {
        if rowNumber < currentPattern.count{
            VStack {
                Text("🧶 Knit!!!").font(.largeTitle)
                Text("You are at the row \(rowNumber)")
                HStack{
                    Text("Follow this pattern: \(currentPattern.count)")
                }
                ScrollView(.horizontal) {
                      HStack {
                          ForEach(0..<10){ i in
                              VStack{
                                  Text("\(currentRow[i].number)")
                                  
                                  Text("\(currentRow[i].abbreviation)")
                              }
                          }
                      }
                  }
                .background(Color.mint)
                
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
