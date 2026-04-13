//
//  ProjectViewModel.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation

@Observable class ProjectViewModel {
    let projectStorage = ProjectStorage()
    var project: Project
    var projectName: String {
        didSet {
            UserDefaults.standard.set(projectName, forKey: "projectName")
            do {
                self.project = try projectStorage.loadProject(name: projectName)
            } catch {
                self.project = Project.bananaSocks
            }
        }
    }

    init(projectName: String? = nil) {
        let name = projectName ?? UserDefaults.standard.string(forKey: "projectName") ?? "banana-socks"
        let storage = ProjectStorage()
        do {
            self.project = try storage.loadProject(name: name)
            self.projectName = name
        } catch {
            self.project = Project.bananaSocks
            self.projectName = "banana-socks"
        }
    }
    
    func addProjectPart(name: String) {
        self.project.addProjectPart(name: name)
        do {
            try projectStorage.saveProject(project: project)
        }
        catch {
            return
        }
    }
    
    func getProjectPartNames() -> [String] {
        project.projectParts.map { $0.name }
    }
    
}
