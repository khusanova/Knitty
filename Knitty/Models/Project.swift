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
        var patternRowCounters: [Int]
        var totalRowCounter: Int {
            patternRowCounters.reduce(0, +)
        }
        
        init(name: String, patterns: [Pattern]){
            self.name = name
            self.patternOrder = patterns.map { $0.id }
            self.patternRowCounters = (0..<patternOrder.count).map {_ in 0}
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
    
    func totalRowCount(projectPart: ProjectPart) -> Int {
        projectPart.patternOrder.compactMap { patterns[$0]?.count ?? 0}.reduce(0,+)
    }
    
    func getRow(indexRow: Int, indexPart: Int) -> Row? {
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
            guard let pattern = patterns[patternID] else {
                return nil
            }
            if indexRow < pattern.count {
                return pattern.getRow(at: indexRow)
            }
            else {
                indexRow -= pattern.count
            }
        }
        return nil
    }
}
