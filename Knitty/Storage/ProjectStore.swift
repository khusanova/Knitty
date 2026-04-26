//
//  ProjectStore.swift
//  Knitty
//
//  Created by Y. Khusanova on 16.04.26.
//

import Foundation

@Observable class ProjectStore {
    private let storage: ProjectStorage
    private(set) var entries: [ProjectIndexEntry]

    init(storage: ProjectStorage = ProjectStorage()) {
        self.storage = storage
        self.entries = (try? storage.loadIndex().entries) ?? []
    }

    func loadProject(id: UUID) throws -> Project {
        try storage.loadProject(id: id)
    }
    
    func createProject(name: String) -> Project {
        Project(name: name, projectParts: [])
    }

    func renameProject(id: UUID, to newName: String) throws {
        var project = try loadProject(id: id)
        project.name = newName
        try saveProject(project)
    }

    func saveProject(_ project: Project) throws {
        try storage.saveProject(project)
        if let idx = entries.firstIndex(where: { $0.id == project.id }) {
            if entries[idx].name != project.name {
                entries[idx].name = project.name
                try persistIndex()
            }
        } else {
            entries.append(ProjectIndexEntry(id: project.id, name: project.name))
            try persistIndex()
        }
    }

    func deleteProject(id: UUID) throws {
        try storage.deleteProject(id: id)
        if let idx = entries.firstIndex(where: { $0.id == id }) {
            entries.remove(at: idx)
            try persistIndex()
        }
        if UserDefaults.standard.string(forKey: "lastProjectID") == id.uuidString {
            UserDefaults.standard.removeObject(forKey: "lastProjectID")
        }
    }

    private func persistIndex() throws {
        try storage.saveIndex(ProjectIndex(entries: entries))
    }
}
