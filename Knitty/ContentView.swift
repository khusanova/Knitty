//
//  ContentView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI

struct ContentView: View {
    @State private var rowsNumber = 0
    @State private var currentPattern = ["k","p"]
    var fullPattern: [String]{ generateFullPattern(pattern: currentPattern, n: 50)
    }
    var body: some View {
        VStack {
            Text("🧶 Knit!!!").font(.largeTitle)
            Text("Number of completed rows: \(rowsNumber)")
            Text("You are at the row \(rowsNumber+1)")
            HStack{
                Text("Follow this pattern: ")
            }
            ScrollView(.horizontal) {
                  HStack {
                      ForEach(0..<50){ i in
                          VStack{
                              Text("\(i)")
                              Text("\(fullPattern[i])")
                          }
                      }
                  }
              }
            .background(Color.mint)
            
            HStack {
                  Button("-1") {
                      rowsNumber -= 1
                  }
                                                                                                      
                  Button("+1") {
                      rowsNumber += 1
                  }
              }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
