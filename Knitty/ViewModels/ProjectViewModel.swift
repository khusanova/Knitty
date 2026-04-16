//
//  ProjectViewModel.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation

@Observable class ProjectViewModel {
    let projectStorage: ProjectStorage
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

    init(projectName: String? = nil, projectStorage: ProjectStorage = ProjectStorage()) {
        self.projectStorage = projectStorage
        let name = projectName ?? UserDefaults.standard.string(forKey: "projectName") ?? "banana-socks"
        do {
            self.project = try projectStorage.loadProject(name: name)
            self.projectName = name
        } catch {
            self.project = Project.bananaSocks
            self.projectName = "banana-socks"
        }
    }

    func save() {
        try? projectStorage.saveProject(project: project)
    }

    func addProjectPart(name: String) {
        project.addProjectPart(name: name)
        save()
    }

    func getProjectPartNames() -> [String] {
        project.projectParts.map { $0.name }
    }

    func makeKnittingViewModel(partIndex: Int) -> KnittingViewModel {
        KnittingViewModel(projectVM: self, partIndex: partIndex)
    }
}
