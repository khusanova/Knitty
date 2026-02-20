//
//  Project.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation

struct Project: Codable, Identifiable{
    var id = UUID()
    var name: String
    struct ProjectPart: Codable, Identifiable{
        var id = UUID()
        var name: String
        var patternOrder: [UUID]
        var rowCounter: Int
        var isFinished: Bool
        
        init(name: String, patterns: [Pattern]){
            self.name = name
            self.patternOrder = patterns.map { $0.id }
            self.rowCounter = 0
            self.isFinished = false
        }
    }
    var projectParts: [ProjectPart]
    var patterns: [UUID: Pattern]
    var currentProjectPart: Int?
    var description: String?
    var projectURL: URL?
    
    init(name: String, projectParts: [(String, [Pattern])], description: String? = nil, projectURL: URL? = nil){
        self.name = name
        self.projectParts = []
        self.patterns = [:]
        for (partName, partPatterns) in projectParts{
            self.projectParts.append(ProjectPart(name: partName, patterns: partPatterns))
            for pattern in partPatterns{
                self.patterns[pattern.id] = pattern
            }
        }
        self.description = description
        self.projectURL = projectURL
    }
    
    func totalRowCount(of projectPartIndex: Int) -> Int {
        projectParts[projectPartIndex].patternOrder.compactMap { patterns[$0]?.count ?? 0}.reduce(0,+)
    }
    
    func getPattern(indexRow: Int, indexPart: Int) -> Pattern? {
        let projectPart = projectParts[indexPart]
        var indexRow = indexRow
        var patternIDIter = projectPart.patternOrder.makeIterator()
        guard indexRow >= 0 else {
            return nil
        }
        while indexRow >= 0 {
            guard let patternID = patternIDIter.next() else {
                return nil
            }
            guard var pattern = patterns[patternID] else {
                return nil
            }
            if indexRow < pattern.count {
                pattern.rowCounter = indexRow
                return pattern//.getRow(at: indexRow)
            }
            else {
                indexRow -= pattern.count
            }
        }
        return nil
    }
    
    func getRow(indexRow: Int, indexPart: Int) -> Row? {
        guard let pattern = getPattern(indexRow: indexRow, indexPart: indexPart) else {
            return nil
        }
        return pattern.getCurrentRow()
    }
    
    mutating func addProgressOnProjectPart(at rowIndex: Int, for projectPartIndex: Int) {
        guard projectPartIndex < projectParts.count else {
            return
        }
        guard projectPartIndex >= 0 else {
            return
        }
        guard projectPartIndex <= totalRowCount(of: projectPartIndex) else{
            return
        }
        projectParts[projectPartIndex].rowCounter = rowIndex
        if rowIndex == totalRowCount(of: projectPartIndex) {
            projectParts[projectPartIndex].isFinished = true
        }
    }
}
