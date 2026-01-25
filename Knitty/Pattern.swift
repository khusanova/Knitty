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

struct Row: Identifiable, Codable {
    var id = UUID()
    var elements: [RowElement]
    var completed: Bool = false
    var count: Int {
        return elements.count
    }
    
    init(stitches: [String], rowExtras: [Int: String] = [:]) {
        var rowElements: [RowElement] = []
        
        for i in 1...stitches.count {
            rowElements.append(RowElement(number: "\(i)", abbreviation: stitches[i-1]))
        }
        
        if Self.checkExtrasIndexes(rowExtras, count: stitches.count) {
            let sortedExtras = rowExtras.sorted {$0.key > $1.key}
            for (position, abbreviation) in sortedExtras{
                let elementType = RowElementType(from: abbreviation)
                switch elementType{
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
        
    mutating func append(_ row: Row){
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
        guard newExtras.allSatisfy( {$0.key < count}) else {
            return false
        }
        return true
    }
    
    static func + (lhs: Row, rhs: Row) -> Row{
        var result = lhs
        result.append(rhs)
        return result
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
    
    init(rows: [Row], name: String? = nil, details: String? = nil, patternURL: URL? = nil){
        self.rows = rows
        self.name = name
        self.details = details
        self.patternURL = patternURL
    }
    
    init(baseRow: Row, length: Int, name: String? = nil, details: String? = nil, patternURL: URL? = nil){
        self.rows = (0..<length).map {_ in baseRow}
        self.name = name
        self.details = details
        self.patternURL = patternURL
    }
    
    func displayRow(at index: Int) -> [RowElement]{
        rows[index].elements
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
    
    mutating func append(_ pattern: Pattern){
        self.rows += pattern.rows
    }
    
    static func + (lhs: Pattern, rhs: Pattern) -> Pattern{
        var result = lhs
        result.append(rhs)
        return result
    }
}

extension Row{
    static let ribbing1x1 = ["k", "p"]
    static let ribbing2x2 = ["k", "k", "p", "p"]
    static let knit = ["k"]
    static let purl = ["p"]
}

extension Pattern{
    static let example = Pattern(baseRow: Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 42)), length: 47, name: "Example Pattern")
    static let bananaSockTop = Pattern(baseRow: Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 56), rowExtras: Dictionary(uniqueKeysWithValues: (1...4).map{ ($0*14, "end of needle")})), length: 15, name: "Banana Sock", patternURL: URL(filePath: "https://www.kotona.com/articles/banana-socks"))
    static let bananaSockKnitRow = Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 14), rowExtras: [14: "end of needle"]) +
    Row(stitches: Row.generateStitches(basePattern: Row.knit, n: 26), rowExtras: [14: "end of needle", 26: "end of needle"]) +
    Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 16), rowExtras: [16: "end of needle"])
    static let bananaSockPurlRow = Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 14), rowExtras: [14: "end of needle"]) +
    Row(stitches: Row.generateStitches(basePattern: Row.purl, n: 26), rowExtras: [14: "end of needle", 26: "end of needle"]) +
    Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 16), rowExtras: [16: "end of needle"])
    static let bananaSockBody = (0..<10).map{ _ in Pattern(baseRow: Pattern.bananaSockKnitRow, length: 5) + Pattern(baseRow: Pattern.bananaSockPurlRow, length: 5)}.reduce(bananaSockTop,+)
    static let rowDecreases = (7...14).reversed().map {Row(stitches: Row.generateStitches(basePattern: Row.knit, n: $0), rowExtras: [$0-3: "k2tog"]) +
        Row(stitches: Row.generateStitches(basePattern: Row.knit, n: $0), rowExtras: [2: "skp"]) +
        Row(stitches: Row.generateStitches(basePattern: Row.knit, n: $0), rowExtras: [$0-3: "k2tog"]) +
        Row(stitches: Row.generateStitches(basePattern: Row.knit, n: $0), rowExtras: [2: "skp"])}
    static let bananaSock = Pattern.bananaSockBody + Pattern(rows: rowDecreases)
}
