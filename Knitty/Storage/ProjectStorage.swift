//
//  ProjectStorage.swift
//  Knitty
//
//  Created by Y. Khusanova on 12.04.26.
//

import Foundation

struct ProjectIndexEntry: Codable, Identifiable {
    let id: UUID
    var name: String
}

struct ProjectIndex: Codable {
    var entries: [ProjectIndexEntry]
}

class ProjectStorage {
    static let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let indexFileName = "index.json"

    private func projectURL(for id: UUID) -> URL {
        Self.documentsURL.appendingPathComponent(id.uuidString + ".json")
    }

    private var indexURL: URL {
        Self.documentsURL.appendingPathComponent(Self.indexFileName)
    }

    func loadProject(id: UUID) throws -> Project {
        guard let data = try? Data(contentsOf: projectURL(for: id)) else {
            throw DataError.fileNotFound
        }
        return try JSONDecoder().decode(Project.self, from: data)
    }

    func saveProject(_ project: Project) throws {
        let data = try JSONEncoder().encode(project)
        try data.write(to: projectURL(for: project.id))
    }

    func deleteProject(id: UUID) throws {
        let url = projectURL(for: id)
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }

    func loadIndex() throws -> ProjectIndex {
        guard let data = try? Data(contentsOf: indexURL) else {
            return ProjectIndex(entries: [])
        }
        return try JSONDecoder().decode(ProjectIndex.self, from: data)
    }

    func saveIndex(_ index: ProjectIndex) throws {
        let data = try JSONEncoder().encode(index)
        try data.write(to: indexURL)
    }
}
