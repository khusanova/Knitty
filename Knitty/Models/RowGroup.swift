//
//  RowGroup.swift
//  Knitty
//
//  Created by Y. Khusanova on 20.01.26.
//

import Foundation

struct Row: Identifiable, Codable {
    var id = UUID()
    var instructions: String
}

struct RowGroup: Identifiable, Codable {
    var id = UUID()
    var rows: [Row]
    var rowCounter: Int?
    var name: String?
    var notes: String?
    var count: Int {
        rows.count
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

    func getCurrentRow() -> Row? {
        guard let index = rowCounter else { return nil }
        return getRow(at: index)
    }

    mutating func updateRow(at index: Int, newRow: Row) {
        guard rows.indices.contains(index) else { return }
        rows[index] = newRow
    }

    mutating func appendRow(newRow: Row) {
        rows.append(newRow)
    }

    mutating func appendRowGroup(_ rowGroup: RowGroup) {
        rows += rowGroup.rows
    }

    static func + (lhs: RowGroup, rhs: RowGroup) -> RowGroup {
        var result = lhs
        result.appendRowGroup(rhs)
        return result
    }
}
