//
//  RowGroup.swift
//  Knitty
//
//  Created by Y. Khusanova on 20.01.26.
//

import Foundation
import SwiftData

struct Row: Identifiable, Codable {
    var id = UUID()
    var instructions: String
}

@Model
final class RowGroup {
    var id = UUID()
    var rows: [Row] = []
    var rowCounter: Int = 0
    var name: String?
    var notes: String?
    /// Position within the owning part; SwiftData to-many relationships are unordered.
    var orderIndex: Int = 0
    var part: ProjectPart?

    var count: Int { rows.count }
    var isFinished: Bool { rowCounter >= rows.count }
    var currentRow: Row? {
        guard rowCounter < rows.count else { return nil }
        return rows[rowCounter]
    }

    init(rows: [Row], name: String? = nil, notes: String? = nil) {
        self.rows = rows
        self.name = name
        self.notes = notes
    }

    func getRow(at index: Int) -> Row? {
        guard rows.indices.contains(index) else { return nil }
        return rows[index]
    }

    func updateRow(at index: Int, newRow: Row) {
        guard rows.indices.contains(index) else { return }
        rows[index] = newRow
    }

    func appendRow(newRow: Row) {
        rows.append(newRow)
    }
}
