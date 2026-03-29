//
//  Pattern.swift
//  Knitty
//
//  Created by Y. Khusanova on 20.01.26.
//

import Foundation

struct Row: Identifiable, Codable {
    var id = UUID()
    var instructions: String
}

struct Pattern: Identifiable, Codable {
    var id = UUID()
    var rows: [UUID: Row]
    var rowOrder: [UUID]
    var rowCounter: Int?
    var name: String?
    var details: String?
    var count: Int {
        rowOrder.count
    }
    
    init(rows: [Row], name: String? = nil, details: String? = nil) {
        self.rowOrder = rows.map { $0.id }
        self.rows = Dictionary(rows.map { ($0.id, $0) },
                               uniquingKeysWith: { old, _ in old})
        self.name = name
        self.details = details
    }
    
    init(baseRow: Row, length: Int, name: String? = nil, details: String? = nil) {
        self.rows = [baseRow.id: baseRow]
        self.rowOrder = (0..<length).map { _ in baseRow.id}
        self.name = name
        self.details = details
    }
    
    func getRow(at index: Int) -> Row? {
        guard index >= 0 && index < count else {
            return nil
        }
        guard let row = rows[rowOrder[index]] else {
            return nil
        }
        return row
    }
    
    func getCurrentRow() -> Row? {
        guard let index = rowCounter else {
            return nil
        }
        return getRow(at: index)
    }
    
    mutating func updateRow(at index: Int, newRow: Row) {
        rows[newRow.id] = newRow
        rowOrder[index] = newRow.id
    }
    
    mutating func appendRow(newRow: Row) {
        rows[newRow.id] = newRow
        rowOrder.append(newRow.id)
    }
    
    mutating func appendPattern(_ pattern: Pattern) {
        self.rows.merge(pattern.rows) { existing, _ in existing }
        self.rowOrder += pattern.rowOrder
    }
    
    static func + (lhs: Pattern, rhs: Pattern) -> Pattern {
        var result = lhs
        result.appendPattern(rhs)
        return result
    }
}
