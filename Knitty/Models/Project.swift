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
    var patterns: [UUID]
    var patternRowCounters: [Int]
    var totalRowCount: Int = 0
}

struct Project: Codable, Identifiable{
    var id = UUID()
    var name: String
    var projectParts: [ProjectPart]
    var currentProjectPart: UUID?
    var description: String?
}
