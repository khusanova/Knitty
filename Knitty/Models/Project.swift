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
        var rowGroupOrder: [UUID]
        var rowCounter: Int
        var isFinished: Bool

        init(name: String, rowGroups: [RowGroup]){
            self.name = name
            self.rowGroupOrder = rowGroups.map { $0.id }
            self.rowCounter = 0
            self.isFinished = false
        }
    }
    var projectParts: [ProjectPart]
    var rowGroups: [UUID: RowGroup]
    var currentProjectPart: Int?
    var notes: String?
    var projectURL: URL?

    init(name: String, projectParts: [(String, [RowGroup])], notes: String? = nil, projectURL: URL? = nil){
        self.name = name
        self.projectParts = []
        self.rowGroups = [:]
        for (partName, partRowGroups) in projectParts{
            self.projectParts.append(ProjectPart(name: partName, rowGroups: partRowGroups))
            for rowGroup in partRowGroups{
                self.rowGroups[rowGroup.id] = rowGroup
            }
        }
        self.notes = notes
        self.projectURL = projectURL
    }

    func totalRowCount(of projectPartIndex: Int) -> Int {
        projectParts[projectPartIndex].rowGroupOrder.compactMap { rowGroups[$0]?.count ?? 0}.reduce(0,+)
    }

    func getRowGroup(indexRow: Int, indexPart: Int) -> RowGroup? {
        let projectPart = projectParts[indexPart]
        var indexRow = indexRow
        var rowGroupIDIter = projectPart.rowGroupOrder.makeIterator()
        guard indexRow >= 0 else {
            return nil
        }
        while indexRow >= 0 {
            guard let rowGroupID = rowGroupIDIter.next() else {
                return nil
            }
            guard var rowGroup = rowGroups[rowGroupID] else {
                return nil
            }
            if indexRow < rowGroup.count {
                rowGroup.rowCounter = indexRow
                return rowGroup
            }
            else {
                indexRow -= rowGroup.count
            }
        }
        return nil
    }

    func getRow(indexRow: Int, indexPart: Int) -> Row? {
        guard let rowGroup = getRowGroup(indexRow: indexRow, indexPart: indexPart) else {
            return nil
        }
        return rowGroup.getCurrentRow()
    }

    mutating func addProjectPart(name: String) {
        self.projectParts.append(ProjectPart(name: name, rowGroups: []))
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
    mutating func addEmptyRowGroup(toPartIndex partIndex: Int) -> UUID? {
        guard projectParts.indices.contains(partIndex) else { return nil }
        let newRowGroup = RowGroup(rows: [])
        rowGroups[newRowGroup.id] = newRowGroup
        projectParts[partIndex].rowGroupOrder.append(newRowGroup.id)
        return newRowGroup.id
    }

    mutating func appendRow(toRowGroupID id: UUID, instructions: String) {
        guard rowGroups[id] != nil else { return }
        rowGroups[id]?.appendRow(newRow: Row(instructions: instructions))
    }

    mutating func setRowGroupRepeatCount(
        toPartIndex partIndex: Int,
        atOrderIndex startIndex: Int,
        oldCount: Int,
        newCount: Int
    ) {
        guard projectParts.indices.contains(partIndex) else { return }
        let order = projectParts[partIndex].rowGroupOrder
        let endIndex = startIndex + oldCount
        guard startIndex >= 0, endIndex <= order.count, oldCount > 0, newCount > 0 else { return }
        let id = order[startIndex]
        guard order[startIndex..<endIndex].allSatisfy({ $0 == id }) else { return }
        let replacement = Array(repeating: id, count: newCount)
        projectParts[partIndex].rowGroupOrder.replaceSubrange(startIndex..<endIndex, with: replacement)
    }

    mutating func deleteRowGroup(
        fromPartIndex partIndex: Int,
        atOrderIndex startIndex: Int,
        oldCount: Int
    ) {
        guard projectParts.indices.contains(partIndex) else { return }
        let order = projectParts[partIndex].rowGroupOrder
        let endIndex = startIndex + oldCount
        guard startIndex >= 0, endIndex <= order.count, oldCount > 0 else { return }
        let id = order[startIndex]
        guard order[startIndex..<endIndex].allSatisfy({ $0 == id }) else { return }
        projectParts[partIndex].rowGroupOrder.removeSubrange(startIndex..<endIndex)
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
