//
//  Project.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation
import SwiftData

@Model
final class Project {
    var id = UUID()
    var name: String = ""
    var currentProjectPart: Int?
    var notes: String?
    var projectURL: URL?

    @Relationship(deleteRule: .cascade, inverse: \ProjectPart.project)
    private var parts: [ProjectPart] = []

    /// Parts in display order. The setter reassigns `orderIndex` from array
    /// position and deletes parts that were removed, so index-based mutation
    /// works as it did with a plain array.
    var projectParts: [ProjectPart] {
        get { parts.sorted { $0.orderIndex < $1.orderIndex } }
        set {
            let removed = parts.filter { part in !newValue.contains { $0 === part } }
            for (index, part) in newValue.enumerated() {
                part.orderIndex = index
            }
            parts = newValue
            removed.forEach { modelContext?.delete($0) }
        }
    }

    init(name: String, projectParts: [(String, [RowGroup])], notes: String? = nil, projectURL: URL? = nil) {
        self.name = name
        self.notes = notes
        self.projectURL = projectURL
        var newParts: [ProjectPart] = []
        for (index, spec) in projectParts.enumerated() {
            let part = ProjectPart(name: spec.0, rowGroups: spec.1)
            part.orderIndex = index
            newParts.append(part)
        }
        self.parts = newParts
    }

    func totalRowCount(of projectPartIndex: Int) -> Int {
        projectParts[projectPartIndex].totalRowCount
    }

    /// Returns the row at the global index `indexRow` within the given part,
    /// counting across the part's row groups.
    func getRow(indexRow: Int, indexPart: Int) -> Row? {
        guard projectParts.indices.contains(indexPart), indexRow >= 0 else { return nil }
        var remaining = indexRow
        for group in projectParts[indexPart].rowGroups {
            if remaining < group.count {
                return group.getRow(at: remaining)
            }
            remaining -= group.count
        }
        return nil
    }

    func addProjectPart(name: String) {
        projectParts.append(ProjectPart(name: name, rowGroups: []))
    }

    func renameProjectPart(at index: Int, to newName: String) {
        guard projectParts.indices.contains(index) else { return }
        projectParts[index].name = newName
    }

    func deleteProjectPart(at index: Int) {
        guard projectParts.indices.contains(index) else { return }
        projectParts.remove(at: index)
    }

    @discardableResult
    func addEmptyRowGroup(toPartIndex partIndex: Int) -> UUID? {
        guard projectParts.indices.contains(partIndex) else { return nil }
        let newRowGroup = RowGroup(rows: [])
        projectParts[partIndex].rowGroups.append(newRowGroup)
        return newRowGroup.id
    }

    /// Appends a row to every group in the run `[runStart, runStart + runLength)`.
    /// Editor groups consecutive content-equal RowGroups into a single visual block;
    /// this keeps all copies in that block in sync.
    func appendRow(
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
    func setRowGroupRepeatCount(
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

    func deleteRowGroup(
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

    func knit(partIndex: Int) throws {
        guard projectParts.indices.contains(partIndex) else {
            throw ProjectProgressError.partIndexOutOfRange
        }
        guard let group = projectParts[partIndex].rowGroups.first(where: { !$0.isFinished }) else {
            throw ProjectProgressError.rowIndexOutOfRange
        }
        group.rowCounter += 1
    }

    func unravel(partIndex: Int) throws {
        guard projectParts.indices.contains(partIndex) else {
            throw ProjectProgressError.partIndexOutOfRange
        }
        guard let group = projectParts[partIndex].rowGroups.last(where: { $0.rowCounter > 0 }) else {
            throw ProjectProgressError.rowIndexOutOfRange
        }
        group.rowCounter -= 1
    }
}
