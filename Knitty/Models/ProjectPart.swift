//
//  ProjectPart.swift
//  Knitty
//
//  Created by Y. Khusanova on 10.06.26.
//

import Foundation
import SwiftData

@Model
final class ProjectPart {
    var id = UUID()
    var name: String = ""
    /// Position within the owning project; SwiftData to-many relationships are unordered.
    var orderIndex: Int = 0
    var project: Project?

    @Relationship(deleteRule: .cascade, inverse: \RowGroup.part)
    private var groups: [RowGroup] = []

    /// Groups in pattern order. The setter reassigns `orderIndex` from array
    /// position and deletes groups that were removed, so index-based mutation
    /// (append, replaceSubrange, ...) works as it did with a plain array.
    var rowGroups: [RowGroup] {
        get { groups.sorted { $0.orderIndex < $1.orderIndex } }
        set {
            let removed = groups.filter { group in !newValue.contains { $0 === group } }
            for (index, group) in newValue.enumerated() {
                group.orderIndex = index
            }
            groups = newValue
            removed.forEach { modelContext?.delete($0) }
        }
    }

    init(name: String, rowGroups: [RowGroup]) {
        self.name = name
        for (index, group) in rowGroups.enumerated() {
            group.orderIndex = index
        }
        self.groups = rowGroups
    }

    var totalRowCount: Int { groups.map(\.count).reduce(0, +) }
    var rowCounter: Int { groups.map(\.rowCounter).reduce(0, +) }
    var isFinished: Bool {
        !groups.isEmpty && groups.allSatisfy(\.isFinished)
    }
}
