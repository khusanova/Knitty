//
//  PatternViewModel.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation

@Observable class ProjectViewModel {
    var project: Project
    var projectName: String {
        didSet {
            UserDefaults.standard.set(projectName, forKey: "projectName")
            self.project = ProjectViewModel.loadProject(projectName: projectName)
        }
    }
    var isFinished: Bool = false
    var projectPartIndex: Int?
    var currentRowNumber: Int?
    var currentRow: Row?
    
    init() {
        let defaultProjectName = UserDefaults.standard.string(forKey: "projectName") ?? "banana-socks"
        self.project = ProjectViewModel.loadProject(projectName: defaultProjectName)
        self.projectName = defaultProjectName
    }
    
    func startKnitting(projectPartIndex: Int) {
        self.projectPartIndex = projectPartIndex
        let isFinished = project.projectParts[projectPartIndex].isFinished
        self.isFinished = isFinished
        if !isFinished{
            let rowNumber = project.projectParts[projectPartIndex].rowCounter
            self.currentRowNumber = rowNumber
            self.currentRow = project.getRow(indexRow: rowNumber, indexPart: projectPartIndex) ?? Row(instructions: "This row does not exist.")
        }
    }
    
    func updateCurrentProjectPart() {
        guard let rowNumber = currentRowNumber else {
            return
        }
        guard let partIndex = projectPartIndex else {
            return
        }
        project.addProgressOnProjectPart(at: rowNumber, for: partIndex)
    }
    
    func getProjectPartNames() -> [String] {
        project.projectParts.map { $0.name }
    }
    
    func unravel() {
        guard let rowNumber = currentRowNumber else {
            return
        }
        guard let index = projectPartIndex else {
            return
        }
        guard let currentRow = project.getRow(indexRow: rowNumber - 1, indexPart: index) else {
            return
        }
        self.currentRowNumber = rowNumber - 1
        self.currentRow = currentRow
    }
    
    func knitRow() {
        guard let rowNumber = currentRowNumber else {
            return
        }
        guard let index = projectPartIndex else {
            return
        }
        if rowNumber + 1 == project.totalRowCount(of: index){
            self.isFinished = true
        }
        self.currentRowNumber = rowNumber + 1
        guard let currentRow = project.getRow(indexRow: rowNumber + 1, indexPart: index) else {
            return
        }
        self.currentRow = currentRow
    }
    
    static func loadProject(projectName: String) -> Project {
        do {
            guard let projectFileURL = Bundle.main.url(forResource: projectName, withExtension: "json") else {
                throw DataError.fileNotFound
            }
            let projectData = try Data(contentsOf: projectFileURL)
            return try JSONDecoder().decode(Project.self, from: projectData)
        }
        catch {
            return Project.bananaSocks
        }
    }
}
