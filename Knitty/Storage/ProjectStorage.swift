//
//  ProjectStorage.swift
//  Knitty
//
//  Created by Y. Khusanova on 12.04.26.
//

import Foundation

class ProjectStorage {
    static let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    var savedProjectNames: [String] {
        guard let files = try? FileManager.default.contentsOfDirectory(at: ProjectStorage.documentsURL, includingPropertiesForKeys: nil) else {
            return []
        }
        return files
            .filter { $0.pathExtension == "json" }
            .map { $0.deletingPathExtension().lastPathComponent }
    }
    
    func loadProject(name: String) throws -> Project {
        let projectFileURL = ProjectStorage.documentsURL.appendingPathComponent(name + ".json")
        guard let projectData = try? Data(contentsOf: projectFileURL) else {
            throw DataError.fileNotFound
        }
        return try JSONDecoder().decode(Project.self, from: projectData)
    }
    
    func saveProject(project: Project) throws {
        let fileURL = ProjectStorage.documentsURL.appendingPathComponent(project.name + ".json")
        let projectData = try JSONEncoder().encode(project)
        try projectData.write(to: fileURL)
    }
}
