//
//  ContentView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI

struct ContentView: View {
    @State private var rowNumber = 0
    @State private var currentPattern = Pattern.example
    var currentRow: [RowElement] { currentPattern.displayRow(at: rowNumber)}
    var body: some View {
        VStack {
            Text("🧶 Knit!!!").font(.largeTitle)
            Text("You are at the row \(rowNumber)")
            HStack{
                Text("Follow this pattern: ")
            }
            ScrollView(.horizontal) {
                  HStack {
                      ForEach(0..<currentRow.count){ i in
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
}

#Preview {
    ContentView()
}
