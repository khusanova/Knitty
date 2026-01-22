//
//  Pattern.swift
//  Knitty
//
//  Created by Y. Khusanova on 20.01.26.
//

import Foundation

//struct displayStitch

struct Row: Codable {
    var fullRowPattern: [String]
    var rowExtras: [Int: String]
    var count: Int {
        return fullRowPattern.count
    }
    init(fullRowPattern: [String], rowExtras: [Int: String] = [:]) {
        if Row.checkExtrasIndexes(rowExtras, count: fullRowPattern.count) {
            self.rowExtras = rowExtras
        } else {
            self.rowExtras = rowExtras.filter { $0.key <= fullRowPattern.count }
        }
        self.fullRowPattern = fullRowPattern
    }
    init(basePattern: [String], n numberOfStitches: Int, rowExtras: [Int: String] = [:]) {
        self.fullRowPattern = Row.generateFullRowPattern(basePattern: basePattern, n: numberOfStitches)
        self.rowExtras = rowExtras
    }
    static func generateFullRowPattern(basePattern: [String], n: Int) -> [String] {
        var result: [String] = []
        let length = basePattern.count
        
        for i in 0..<n{
            result.append(basePattern[i % length])
        }
        
        return result
    }
    static func checkExtrasIndexes(_ newExtras: [Int: String], count: Int) -> Bool {
        for i in newExtras.keys{
            guard i <= count else{
                return false
            }
        }
        return true
    }
}

struct Pattern: Identifiable, Codable{
    var id = UUID()
    var name: String
    var rows: [Row]
    mutating func updateRow(at index: Int, newRow: Row){
        guard newRow.count == rows[index].count else{
            return
        }
        rows[index] = newRow
    }
    mutating func addRow(newRow: Row){
        rows.append(newRow)
    }
    mutating func updateRowExtras(at index: Int, newExtras: [Int: String]) {
        guard Row.checkExtrasIndexes(newExtras, count: rows[index].count) else {
            return
        }
        rows[index].rowExtras = newExtras
    }
    mutating func updateFullRowPattern(at index: Int, newPattern: [String]) {
        guard newPattern.count == rows[index].count else{
            return
        }
        rows[index].fullRowPattern = newPattern
    }
}
