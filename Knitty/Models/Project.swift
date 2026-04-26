//
//  Project.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation

struct Project: Codable, Identifiable, Hashable {
    static func == (lhs: Project, rhs: Project) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    var id = UUID()
    var name: String
    struct ProjectPart: Codable, Identifiable{
        var id = UUID()
        var name: String
        var subPatternOrder: [UUID]
        var rowCounter: Int
        var isFinished: Bool

        init(name: String, subPatterns: [SubPattern]){
            self.name = name
            self.subPatternOrder = subPatterns.map { $0.id }
            self.rowCounter = 0
            self.isFinished = false
        }
    }
    var projectParts: [ProjectPart]
    var subPatterns: [UUID: SubPattern]
    var currentProjectPart: Int?
    var notes: String?
    var projectURL: URL?

    init(name: String, projectParts: [(String, [SubPattern])], notes: String? = nil, projectURL: URL? = nil){
        self.name = name
        self.projectParts = []
        self.subPatterns = [:]
        for (partName, partSubPatterns) in projectParts{
            self.projectParts.append(ProjectPart(name: partName, subPatterns: partSubPatterns))
            for subPattern in partSubPatterns{
                self.subPatterns[subPattern.id] = subPattern
            }
        }
        self.notes = notes
        self.projectURL = projectURL
    }
    
    func totalRowCount(of projectPartIndex: Int) -> Int {
        projectParts[projectPartIndex].subPatternOrder.compactMap { subPatterns[$0]?.count ?? 0}.reduce(0,+)
    }

    func getSubPattern(indexRow: Int, indexPart: Int) -> SubPattern? {
        let projectPart = projectParts[indexPart]
        var indexRow = indexRow
        var subPatternIDIter = projectPart.subPatternOrder.makeIterator()
        guard indexRow >= 0 else {
            return nil
        }
        while indexRow >= 0 {
            guard let subPatternID = subPatternIDIter.next() else {
                return nil
            }
            guard var subPattern = subPatterns[subPatternID] else {
                return nil
            }
            if indexRow < subPattern.count {
                subPattern.rowCounter = indexRow
                return subPattern
            }
            else {
                indexRow -= subPattern.count
            }
        }
        return nil
    }

    func getRow(indexRow: Int, indexPart: Int) -> Row? {
        guard let subPattern = getSubPattern(indexRow: indexRow, indexPart: indexPart) else {
            return nil
        }
        return subPattern.getCurrentRow()
    }

    mutating func addProjectPart(name: String) {
        self.projectParts.append(ProjectPart(name: name, subPatterns: []))
    }

    mutating func renameProjectPart(at index: Int, to newName: String) {
        guard projectParts.indices.contains(index) else { return }
        projectParts[index].name = newName
    }

    mutating func deleteProjectPart(at index: Int) {
        guard projectParts.indices.contains(index) else { return }
        projectParts.remove(at: index)
    }

    @discardableResult
    mutating func addEmptySubPattern(toPartIndex partIndex: Int) -> UUID? {
        guard projectParts.indices.contains(partIndex) else { return nil }
        let newSubPattern = SubPattern(rows: [])
        subPatterns[newSubPattern.id] = newSubPattern
        projectParts[partIndex].subPatternOrder.append(newSubPattern.id)
        return newSubPattern.id
    }

    mutating func appendRow(toSubPatternID id: UUID, instructions: String) {
        guard subPatterns[id] != nil else { return }
        subPatterns[id]?.appendRow(newRow: Row(instructions: instructions))
    }

    mutating func setSubPatternRepeatCount(
        toPartIndex partIndex: Int,
        atOrderIndex startIndex: Int,
        oldCount: Int,
        newCount: Int
    ) {
        guard projectParts.indices.contains(partIndex) else { return }
        let order = projectParts[partIndex].subPatternOrder
        let endIndex = startIndex + oldCount
        guard startIndex >= 0, endIndex <= order.count, oldCount > 0, newCount > 0 else { return }
        let id = order[startIndex]
        guard order[startIndex..<endIndex].allSatisfy({ $0 == id }) else { return }
        let replacement = Array(repeating: id, count: newCount)
        projectParts[partIndex].subPatternOrder.replaceSubrange(startIndex..<endIndex, with: replacement)
    }

    mutating func deleteSubPatternGroup(
        fromPartIndex partIndex: Int,
        atOrderIndex startIndex: Int,
        oldCount: Int
    ) {
        guard projectParts.indices.contains(partIndex) else { return }
        let order = projectParts[partIndex].subPatternOrder
        let endIndex = startIndex + oldCount
        guard startIndex >= 0, endIndex <= order.count, oldCount > 0 else { return }
        let id = order[startIndex]
        guard order[startIndex..<endIndex].allSatisfy({ $0 == id }) else { return }
        projectParts[partIndex].subPatternOrder.removeSubrange(startIndex..<endIndex)
    }
    
    mutating func knit(partIndex: Int) throws {
        guard projectParts.indices.contains(partIndex) else {
            throw ProjectProgressError.partIndexOutOfRange
        }
        guard projectParts[partIndex].rowCounter < self.totalRowCount(of: partIndex) else {
            throw ProjectProgressError.rowIndexOutOfRange
        }
        projectParts[partIndex].rowCounter += 1
        if projectParts[partIndex].rowCounter == self.totalRowCount(of: partIndex) {
            projectParts[partIndex].isFinished = true
        }
    }

    mutating func unravel(partIndex: Int) throws {
        guard projectParts.indices.contains(partIndex) else {
            throw ProjectProgressError.partIndexOutOfRange
        }
        guard projectParts[partIndex].rowCounter > 0 else {
            throw ProjectProgressError.rowIndexOutOfRange
        }
        projectParts[partIndex].rowCounter -= 1
        projectParts[partIndex].isFinished = false
    }
}
