//
//  ProjectViewModel.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation

@Observable class ProjectViewModel {
    let store: ProjectStore
    var project: Project

    @ObservationIgnored
    private var knittingViewModelCache: [Int: KnittingViewModel] = [:]

    init(projectID: UUID? = nil, store: ProjectStore) {
        self.store = store
        let id = projectID
            ?? UserDefaults.standard.string(forKey: "lastProjectID").flatMap(UUID.init)
        if let id, let loaded = try? store.loadProject(id: id) {
            self.project = loaded
        } else {
            self.project = Project.bananaSocks
        }
        UserDefaults.standard.set(self.project.id.uuidString, forKey: "lastProjectID")
    }

    func save() {
        try? store.saveProject(project)
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

    func appendRow(toRowGroupID id: UUID, instructions: String) {
        project.appendRow(toRowGroupID: id, instructions: instructions)
        save()
    }

    func addRowToNewRowGroup(toPartIndex partIndex: Int, instructions: String) {
        guard let id = project.addEmptyRowGroup(toPartIndex: partIndex) else { return }
        project.appendRow(toRowGroupID: id, instructions: instructions)
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
