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
        "decrease": ["k2tog"],
        "marker": ["blue", "green"],
        "end of needle": ["blue", "green"]
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

struct RowElement {
    var number: String
    var abbreviation: String
}

struct Row: Codable {
    var fullRowPattern: [String]
    var rowExtras: [Int: String]
    var count: Int {
        return fullRowPattern.count
    }
    
    init(fullRowPattern: [String], rowExtras: [Int: String] = [:]) {
        if Self.checkExtrasIndexes(rowExtras, count: fullRowPattern.count) {
            self.rowExtras = rowExtras
        } else {
            self.rowExtras = rowExtras.filter { $0.key <= fullRowPattern.count }
        }
        self.fullRowPattern = fullRowPattern
    }
    
    init(basePattern: [String], n numberOfStitches: Int, rowExtras: [Int: String] = [:]) {
        self.fullRowPattern = Self.generateFullRowPattern(basePattern: basePattern, n: numberOfStitches)
        self.rowExtras = rowExtras
    }
    
    func displayRow() -> [RowElement] {
        var rowElements: [RowElement] = []
        for i in 1...fullRowPattern.count {
            rowElements.append(RowElement(number: "\(i)", abbreviation: fullRowPattern[i-1]))
        }
        for (position, abbreviation) in rowExtras{
            let elementType = RowElementType(from: abbreviation)
            switch elementType{
            case .increase:
                rowElements.insert(RowElement(number: "\(position)+", abbreviation: abbreviation), at: position)
            case .decrease:
                rowElements[position] = RowElement(number: "-", abbreviation: abbreviation)
            case .marker:
                rowElements[position] = RowElement(number: " ", abbreviation: "M")
            case .endOfNeedle:
                rowElements[position] = RowElement(number: " ", abbreviation: "E")
            default:
                return rowElements //add some warning or error
            }
        }
        return rowElements
    }
    
    mutating func append(_ row: Row){
        self.fullRowPattern += row.fullRowPattern
        for (position, abbreviation) in row.rowExtras{
            self.rowExtras[position+self.count] = abbreviation
        }
    }
    
    static func generateFullRowPattern(basePattern: [String], n: Int) -> [String] {
        var result: [String] = []
        let length = basePattern.count
        
        for i in 0..<n {
            result.append(basePattern[i % length])
        }
        
        return result
    }
    
    static func checkExtrasIndexes(_ newExtras: [Int: String], count: Int) -> Bool {
        guard newExtras.allSatisfy( {$0.key < count}) else {
            return false
        }
        return true
    }
}

struct Pattern: Identifiable, Codable {
    var id = UUID()
    var rows: [Row]
    var name: String?
    var details: String?
    var patternURL: URL?
    var count: Int {
        rows.count
    }
    
    init(baseRow: Row, length: Int, name: String? = nil, details: String? = nil, patternURL: URL? = nil){
        self.rows = (0..<length).map {_ in baseRow}
        self.name = name
        self.details = details
        self.patternURL = patternURL
    }
    
    func displayRow(at index: Int) -> [RowElement]{
        rows[index].displayRow()
    }
    
    mutating func updateRow(at index: Int, newRow: Row) {
        guard newRow.count == rows[index].count else {
            return
        }
        rows[index] = newRow
    }
    
    mutating func addRow(newRow: Row) {
        rows.append(newRow)
    }
    
    mutating func updateRowExtras(at index: Int, newExtras: [Int: String]) {
        guard Row.checkExtrasIndexes(newExtras, count: rows[index].count) else {
            return
        }
        rows[index].rowExtras = newExtras
    }
    
    mutating func updateFullRowPattern(at index: Int, newPattern: [String]) {
        guard newPattern.count == rows[index].count else {
            return
        }
        rows[index].fullRowPattern = newPattern
    }
}

extension Row{
    static let ribbing1x1 = ["k", "p"]
    static let ribbing2x2 = ["k", "k", "p", "p"]
    static let knit = ["k"]
    static let purl = ["p"]
}

extension Pattern{
    static let example = Pattern(name: "Example Pattern", rows: (0..<50).map { _ in Row(basePattern: ["k", "k", "p", "p"], n: 42) })
}
