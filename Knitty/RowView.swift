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
            Text("\(row.instructions)")
          }
    }
}

