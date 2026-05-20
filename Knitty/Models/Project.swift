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
    struct ProjectPart: Codable, Identifiable {
        var id = UUID()
        var name: String
        var rowGroups: [RowGroup]

        init(name: String, rowGroups: [RowGroup]) {
            self.name = name
            self.rowGroups = rowGroups
        }

        var totalRowCount: Int { rowGroups.map(\.count).reduce(0, +) }
        var rowCounter: Int { rowGroups.map(\.rowCounter).reduce(0, +) }
        var isFinished: Bool {
            !rowGroups.isEmpty && rowGroups.allSatisfy(\.isFinished)
        }
    }
    var projectParts: [ProjectPart]
    var currentProjectPart: Int?
    var notes: String?
    var projectURL: URL?

    init(name: String, projectParts: [(String, [RowGroup])], notes: String? = nil, projectURL: URL? = nil) {
        self.name = name
        self.projectParts = projectParts.map { ProjectPart(name: $0.0, rowGroups: $0.1) }
        self.notes = notes
        self.projectURL = projectURL
    }

    func totalRowCount(of projectPartIndex: Int) -> Int {
        projectParts[projectPartIndex].totalRowCount
    }

    /// Returns the group containing the global row `indexRow` within the given part,
    /// with its `rowCounter` set to the row's local index within that group.
    func getRowGroup(indexRow: Int, indexPart: Int) -> RowGroup? {
        guard projectParts.indices.contains(indexPart), indexRow >= 0 else { return nil }
        var remaining = indexRow
        for group in projectParts[indexPart].rowGroups {
            if remaining < group.count {
                var copy = group
                copy.rowCounter = remaining
                return copy
            }
            remaining -= group.count
        }
        return nil
    }

    func getRow(indexRow: Int, indexPart: Int) -> Row? {
        getRowGroup(indexRow: indexRow, indexPart: indexPart)?.currentRow
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
        projectParts[partIndex].rowGroups.append(newRowGroup)
        return newRowGroup.id
    }

    /// Appends a row to every group in the run `[runStart, runStart + runLength)`.
    /// Editor groups consecutive content-equal RowGroups into a single visual block;
    /// this keeps all copies in that block in sync.
    mutating func appendRow(
        toPartIndex partIndex: Int,
        runStart: Int,
        runLength: Int,
        instructions: String
    ) {
        guard projectParts.indices.contains(partIndex) else { return }
        let endIndex = runStart + runLength
        guard runStart >= 0,
              endIndex <= projectParts[partIndex].rowGroups.count,
              runLength > 0 else { return }
        for i in runStart..<endIndex {
            projectParts[partIndex].rowGroups[i].appendRow(newRow: Row(instructions: instructions))
        }
    }

    /// Replaces `[startIndex, startIndex + oldCount)` with `newCount` copies of the first
    /// group in the run: the original is preserved (id and progress intact), the additional
    /// copies are fresh (new UUIDs, rowCounter = 0).
    mutating func setRowGroupRepeatCount(
        toPartIndex partIndex: Int,
        atOrderIndex startIndex: Int,
        oldCount: Int,
        newCount: Int
    ) {
        guard projectParts.indices.contains(partIndex) else { return }
        let groups = projectParts[partIndex].rowGroups
        let endIndex = startIndex + oldCount
        guard startIndex >= 0, endIndex <= groups.count, oldCount > 0, newCount > 0 else { return }
        let template = groups[startIndex]
        var replacement: [RowGroup] = [template]
        for _ in 1..<newCount {
            replacement.append(RowGroup(
                rows: template.rows.map { Row(instructions: $0.instructions) },
                name: template.name,
                notes: template.notes
            ))
        }
        projectParts[partIndex].rowGroups.replaceSubrange(startIndex..<endIndex, with: replacement)
    }

    mutating func deleteRowGroup(
        fromPartIndex partIndex: Int,
        atOrderIndex startIndex: Int,
        oldCount: Int
    ) {
        guard projectParts.indices.contains(partIndex) else { return }
        let endIndex = startIndex + oldCount
        guard startIndex >= 0,
              endIndex <= projectParts[partIndex].rowGroups.count,
              oldCount > 0 else { return }
        projectParts[partIndex].rowGroups.removeSubrange(startIndex..<endIndex)
    }

    mutating func knit(partIndex: Int) throws {
        guard projectParts.indices.contains(partIndex) else {
            throw ProjectProgressError.partIndexOutOfRange
        }
        guard let groupIndex = projectParts[partIndex].rowGroups.firstIndex(where: { !$0.isFinished }) else {
            throw ProjectProgressError.rowIndexOutOfRange
        }
        projectParts[partIndex].rowGroups[groupIndex].rowCounter += 1
    }

    mutating func unravel(partIndex: Int) throws {
        guard projectParts.indices.contains(partIndex) else {
            throw ProjectProgressError.partIndexOutOfRange
        }
        guard let groupIndex = projectParts[partIndex].rowGroups.lastIndex(where: { $0.rowCounter > 0 }) else {
            throw ProjectProgressError.rowIndexOutOfRange
        }
        projectParts[partIndex].rowGroups[groupIndex].rowCounter -= 1
    }
}
