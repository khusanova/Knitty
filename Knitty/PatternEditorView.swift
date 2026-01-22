//
//  PatternEditorView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI

struct PatternEditorView: View {
    let buttonNames = [["k1", "p1"],
                       ["m1l", "m1r"]]
    @State private var currentPattern: [String] = []
    var body: some View {
        VStack{
            ForEach(0..<2){i in
                HStack{
                    ForEach(0..<2){j in
                        Button(buttonNames[i][j]){
                            currentPattern.append(buttonNames[i][j])
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    PatternEditorView()
}
