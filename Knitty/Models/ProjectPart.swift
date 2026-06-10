//
//  ProjectPart.swift
//  Knitty
//
//  Created by Y. Khusanova on 10.06.26.
//

import Foundation

struct ProjectPart: Codable, Identifiable {
    var id = UUID()
    var name: String
    var rowGroups: [RowGroup]

    init(name: String, rowGroups: [RowGroup]) {
        self.name = name
        self.rowGroups = rowGroups
    }

    var totalRowCount: Int { rowGroups.map(\.count).reduce(0, +) }
    var rowCounter: Int { rowGroups.map(\.rowCounter).reduce(0, +) }
    var isFinished: Bool {
        !rowGroups.isEmpty && rowGroups.allSatisfy(\.isFinished)
    }
}
