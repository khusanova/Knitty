//
//  SubPatternEditorView.swift
//  Knitty
//
//  Created by Y. Khusanova on 19.01.26.
//

import SwiftUI

struct SubPatternEditorView: View {
    let buttonNames = [["k1", "p1"],
                       ["m1l", "m1r"]]
    @State private var currentSubPattern: [String] = []
    var body: some View {
        VStack{
            ForEach(0..<2){i in
                HStack{
                    ForEach(0..<2){j in
                        Button(buttonNames[i][j]){
                            currentSubPattern.append(buttonNames[i][j])
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SubPatternEditorView()
}
