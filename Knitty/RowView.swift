//
//  RowView.swift
//  Knitty
//
//  Created by Y. Khusanova on 26.01.26.
//

import SwiftUI

struct RowView: View {
    let row: Row
    var body: some View{
        ScrollView(.horizontal) {
              HStack {
                  ForEach(row.elements){ element in
                      VStack{
                          Text("\(element.number)")
                          
                          Text("\(element.abbreviation)")
                      }
                  }
              }
          }
        .background(Color.mint)
    }
}

