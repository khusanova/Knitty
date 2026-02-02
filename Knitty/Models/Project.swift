//
//  Project.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation

struct ProjectPart: Codable, Identifiable{
    var id = UUID()
    var name: String
    var patternOrder: [UUID]
    var patternRowCounters: [Int]
    var totalRowCounter: Int {
        patternRowCounters.reduce(0, +)
    }
    
    init(name: String, patternOrder: [UUID], ProjectPartURL: URL? = nil){
        self.name = name
        self.patternOrder = patternOrder
        self.patternRowCounters = (0..<patternOrder.count).map {_ in 0}
    }
}

struct Project: Codable, Identifiable{
    var id = UUID()
    var name: String
    var projectParts: [ProjectPart]
    var patterns: [UUID: Pattern]
    var currentProjectPart: UUID?
    var description: String?
    
    func totalRowCount(projectPart: ProjectPart) -> Int {
        projectPart.patternOrder.compactMap { patterns[$0]?.count ?? 0}.reduce(0,+)
    }
}
