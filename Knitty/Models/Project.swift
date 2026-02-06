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
        
        init(name: String, patterns: [Pattern], ProjectPartURL: URL? = nil){
            self.name = name
            self.patternOrder = patterns.map { $0.id }
            self.patternRowCounters = (0..<patternOrder.count).map {_ in 0}
        }
    }
    var projectParts: [ProjectPart]
    var patterns: [UUID: Pattern]
    var currentProjectPart: UUID?
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
}
