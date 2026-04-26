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
        save()
    }

    @discardableResult
    func addEmptySubPattern(toPartIndex partIndex: Int) -> UUID? {
        let id = project.addEmptySubPattern(toPartIndex: partIndex)
        save()
        return id
    }

    func appendRow(toSubPatternID id: UUID, instructions: String) {
        project.appendRow(toSubPatternID: id, instructions: instructions)
        save()
    }

    func addRowToNewSubPattern(toPartIndex partIndex: Int, instructions: String) {
        guard let id = project.addEmptySubPattern(toPartIndex: partIndex) else { return }
        project.appendRow(toSubPatternID: id, instructions: instructions)
        save()
    }

    func setSubPatternRepeatCount(
        toPartIndex partIndex: Int,
        atOrderIndex startIndex: Int,
        oldCount: Int,
        newCount: Int
    ) {
        project.setSubPatternRepeatCount(
            toPartIndex: partIndex,
            atOrderIndex: startIndex,
            oldCount: oldCount,
            newCount: newCount
        )
        save()
    }

    func deleteSubPatternGroup(
        fromPartIndex partIndex: Int,
        atOrderIndex startIndex: Int,
        oldCount: Int
    ) {
        project.deleteSubPatternGroup(
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
        KnittingViewModel(projectVM: self, partIndex: partIndex)
    }
}
