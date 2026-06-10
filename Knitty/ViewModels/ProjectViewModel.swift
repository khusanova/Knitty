//
//  ProjectViewModel.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation

@Observable class ProjectViewModel {
    var project: Project

    @ObservationIgnored
    private var knittingViewModelCache: [Int: KnittingViewModel] = [:]

    init(project: Project) {
        self.project = project
    }

    func save() {
        try? project.modelContext?.save()
    }

    func addProjectPart(name: String) {
        project.addProjectPart(name: name)
        save()
    }

    func renameProjectPart(at index: Int, to newName: String) {
        project.renameProjectPart(at: index, to: newName)
        save()
    }

    func deleteProjectPart(at index: Int) {
        project.deleteProjectPart(at: index)
        knittingViewModelCache.removeAll()
        save()
    }

    @discardableResult
    func addEmptyRowGroup(toPartIndex partIndex: Int) -> UUID? {
        let id = project.addEmptyRowGroup(toPartIndex: partIndex)
        save()
        return id
    }

    func appendRow(
        toPartIndex partIndex: Int,
        runStart: Int,
        runLength: Int,
        instructions: String
    ) {
        project.appendRow(
            toPartIndex: partIndex,
            runStart: runStart,
            runLength: runLength,
            instructions: instructions
        )
        save()
    }

    func addRowToNewRowGroup(toPartIndex partIndex: Int, instructions: String) {
        guard project.addEmptyRowGroup(toPartIndex: partIndex) != nil else { return }
        let groups = project.projectParts[partIndex].rowGroups
        project.appendRow(
            toPartIndex: partIndex,
            runStart: groups.count - 1,
            runLength: 1,
            instructions: instructions
        )
        save()
    }

    func setRowGroupRepeatCount(
        toPartIndex partIndex: Int,
        atOrderIndex startIndex: Int,
        oldCount: Int,
        newCount: Int
    ) {
        project.setRowGroupRepeatCount(
            toPartIndex: partIndex,
            atOrderIndex: startIndex,
            oldCount: oldCount,
            newCount: newCount
        )
        save()
    }

    func deleteRowGroup(
        fromPartIndex partIndex: Int,
        atOrderIndex startIndex: Int,
        oldCount: Int
    ) {
        project.deleteRowGroup(
            fromPartIndex: partIndex,
            atOrderIndex: startIndex,
            oldCount: oldCount
        )
        save()
    }

    func getProjectPartNames() -> [String] {
        project.projectParts.map { $0.name }
    }

    func makeKnittingViewModel(partIndex: Int) -> KnittingViewModel {
        if let cached = knittingViewModelCache[partIndex] {
            return cached
        }
        let vm = KnittingViewModel(projectVM: self, partIndex: partIndex)
        knittingViewModelCache[partIndex] = vm
        return vm
    }
}
