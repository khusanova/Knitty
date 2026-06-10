//
//  ProjectStore.swift
//  Knitty
//
//  Created by Y. Khusanova on 16.04.26.
//

import Foundation
import SwiftData

struct ProjectIndexEntry: Identifiable {
    let id: UUID
    var name: String
}

@Observable class ProjectStore {
    @ObservationIgnored
    private let context: ModelContext
    private(set) var entries: [ProjectIndexEntry] = []

    init(context: ModelContext) {
        self.context = context
        refreshEntries()
    }

    func loadProject(id: UUID) throws -> Project {
        // Filtered in memory: a #Predicate on `id` can collide with
        // PersistentModel's own identifier in current SwiftData versions.
        guard let project = try context.fetch(FetchDescriptor<Project>())
            .first(where: { $0.id == id }) else {
            throw DataError.fileNotFound
        }
        return project
    }

    func createProject(name: String) -> Project {
        Project(name: name, projectParts: [])
    }

    func renameProject(id: UUID, to newName: String) throws {
        let project = try loadProject(id: id)
        project.name = newName
        try saveProject(project)
    }

    func saveProject(_ project: Project) throws {
        if project.modelContext == nil {
            context.insert(project)
        }
        try context.save()
        refreshEntries()
    }

    func deleteProject(id: UUID) throws {
        guard let project = try? loadProject(id: id) else { return }
        context.delete(project)
        try context.save()
        refreshEntries()
        if UserDefaults.standard.string(forKey: "lastProjectID") == id.uuidString {
            UserDefaults.standard.removeObject(forKey: "lastProjectID")
        }
    }

    private func refreshEntries() {
        let descriptor = FetchDescriptor<Project>(sortBy: [SortDescriptor(\.name)])
        let projects = (try? context.fetch(descriptor)) ?? []
        entries = projects.map { ProjectIndexEntry(id: $0.id, name: $0.name) }
    }
}
