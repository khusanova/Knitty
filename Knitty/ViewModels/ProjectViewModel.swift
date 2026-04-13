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
            self.project = ProjectViewModel.loadProject(projectName: projectName)
        }
    }
    var isFinished: Bool = false
    var currentPosition: (partIndex: Int, rowNumber: Int)? {
        didSet {
            if let position = currentPosition {
                UserDefaults.standard.set(position.partIndex, forKey: "currentPartIndex")
                UserDefaults.standard.set(position.rowNumber, forKey: "currentRowNumber")
            }
            else {
                UserDefaults.standard.removeObject(forKey: "currentPartIndex")
                UserDefaults.standard.removeObject(forKey: "currentRowNumber")
            }
        }
    }
    var currentRow: Row?
    
    init(projectName: String? = nil) {
        let projectName = projectName ?? UserDefaults.standard.string(forKey: "projectName") ?? "banana-socks"
        do {
            self.project = try projectStorage.loadProject(name: projectName)
            self.projectName = projectName
        }
        catch {
            self.project = Project.bananaSocks
            self.projectName = "banana-socks"
        }
        let partIndex = UserDefaults.standard.object(forKey: "currentPartIndex") as? Int
        let rowNumber = UserDefaults.standard.object(forKey: "currentRowNumber") as? Int
        if let partIndex, let rowNumber {
            self.currentPosition = (partIndex, rowNumber)
        }
    }
    
    func addProjectPart(name: String) {
        self.project.addProjectPart(name: name)
    }
    
    func startKnitting(projectPartIndex: Int) {
        do {
            try projectStorage.saveProject(project: project)
        }
        catch {
            return
        }
        let isFinished = project.projectParts[projectPartIndex].isFinished
        self.isFinished = isFinished
        if !isFinished {
            let rowNumber = project.projectParts[projectPartIndex].rowCounter
            self.currentPosition = (projectPartIndex, rowNumber)
            self.currentRow = project.getRow(indexRow: rowNumber, indexPart: projectPartIndex) ?? Row(instructions: "This row does not exist.")
        }
    }
    
    func updateCurrentProjectPart() {
        guard let (partIndex, rowNumber) = currentPosition else {
            return
        }
        project.addProgressOnProjectPart(at: rowNumber, for: partIndex)
    }
    
    func getProjectPartNames() -> [String] {
        project.projectParts.map { $0.name }
    }
    
    func unravel() {
        guard var (partIndex, rowNumber) = currentPosition else {
            return
        }
        guard let currentRow = project.getRow(indexRow: rowNumber - 1, indexPart: partIndex) else {
            return
        }
        rowNumber -= 1
        self.currentRow = currentRow
        self.currentPosition = (partIndex, rowNumber)
    }
    
    func knitRow() {
        guard var (partIndex, rowNumber) = currentPosition else {
            return
        }
        if rowNumber + 1 == project.totalRowCount(of: partIndex) {
            self.isFinished = true
        }
        guard let currentRow = project.getRow(indexRow: rowNumber + 1, indexPart: partIndex) else {
            return
        }
        rowNumber += 1
        self.currentRow = currentRow
        self.currentPosition = (partIndex, rowNumber)
    }
}
