//
//  Pattern.swift
//  Knitty
//
//  Created by Y. Khusanova on 20.01.26.
//

import Foundation

enum RowElementType {
    case stitch, marker, increase, decrease, endOfNeedle
    static let abbreviations = [
        "stitch": ["k", "p"],
        "increase": ["m1l", "m1r"],
        "decrease": ["k2tog", "skp"],
        "marker": ["blue", "green", "yellow", "magenta", "red", "orange"],
        "end of needle": ["end of needle"]
    ]
    
    init?(from abbreviation: String) {
        guard let elementType = Self.abbreviations.first(where: { $0.value.contains(abbreviation) }) else {
            return nil
        }
        switch elementType.key {
        case "stitch": self = .stitch
        case "increase": self = .increase
        case "decrease": self = .decrease
        case "marker": self = .marker
        case "end of needle": self = .endOfNeedle
        default: return nil
        }
    }
}

struct RowElement: Identifiable, Codable {
    var id = UUID()
    var number: String
    var abbreviation: String
}

struct LiteRow: Identifiable, Codable {
    var id = UUID()
    var instructions: String
}

typealias Row = LiteRow

struct ParsedRow: Identifiable, Codable {
    var id = UUID()
    var elements: [RowElement]
    var completed: Bool = false
    var count: Int {
        elements.count
    }
    
    init(stitches: [String], rowExtras: [Int: String] = [:]) {
        var rowElements: [RowElement] = []
        
        for i in 1...stitches.count {
            rowElements.append(RowElement(number: "\(i)", abbreviation: stitches[i-1]))
        }
        
        if Self.checkExtrasIndexes(rowExtras, count: stitches.count) {
            let sortedExtras = rowExtras.sorted {$0.key > $1.key}
            for (position, abbreviation) in sortedExtras {
                let elementType = RowElementType(from: abbreviation)
                switch elementType {
                case .increase:
                    rowElements.insert(RowElement(number: "\(position)+", abbreviation: abbreviation), at: position)
                case .decrease:
                    rowElements[position] = RowElement(number: "-", abbreviation: abbreviation)
                case .marker:
                    rowElements[position] = RowElement(number: " ", abbreviation: "M")
                case .endOfNeedle:
                    rowElements.insert(RowElement(number: " ", abbreviation: "E"), at: position)
                default:
                    self.elements = rowElements //add some warning or error
                }
            }
        } else {
            self.elements = rowElements
        }
        
        self.elements = rowElements
    }
        
    mutating func append(_ row: ParsedRow) {
        self.elements += row.elements
    }
    
    static func generateStitches(basePattern: [String], n: Int) -> [String] {
        var result: [String] = []
        let length = basePattern.count
        
        for i in 0..<n {
            result.append(basePattern[i % length])
        }
        
        return result
    }
    
    static func checkExtrasIndexes(_ newExtras: [Int: String], count: Int) -> Bool {
        guard newExtras.allSatisfy({ $0.key < count }) else {
            return false
        }
        return true
    }
    
    static func + (lhs: ParsedRow, rhs: ParsedRow) -> ParsedRow {
        var result = lhs
        result.append(rhs)
        return result
    }
}

struct Pattern: Identifiable, Codable {
    var id = UUID()
    var rows: [UUID: Row]
    var rowOrder: [UUID]
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
