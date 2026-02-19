//
//  PatternViewModel.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation

@Observable class ProjectViewModel {
    var project: Project
    var projectPartIndex: Int?
    var currentRowNumber: Int?
    var currentRow: Row?
    
    init() {
        do {
            guard let projectFileURL = Bundle.main.url(forResource: "banana-socks", withExtension: "json") else {
                throw DataError.fileNotFound
            }
            let projectData = try Data(contentsOf: projectFileURL)
            self.project = try JSONDecoder().decode(Project.self, from: projectData)
        }
        catch {
            self.project = Project.bananaSocks
        }
    }
    
    func startKnitting(projectPartIndex: Int) {
        self.projectPartIndex = projectPartIndex
        let rowNumber = project.projectParts[projectPartIndex].rowCounter
        self.currentRowNumber = rowNumber
        self.currentRow = project.getRow(indexRow: rowNumber, indexPart: projectPartIndex) ?? Row(instructions: "This row does not exist.")
    }
    
    func isFinishedProjectPart() -> Bool {
        guard let rowNumber = currentRowNumber else {
            return false
        }
        guard let index = projectPartIndex else {
            return false
        }
        return rowNumber  == project.totalRowCount(of: index)
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
        guard let currentRow = project.getRow(indexRow: rowNumber + 1, indexPart: index) else {
            return
        }
        self.currentRowNumber = rowNumber + 1
        self.currentRow = currentRow
    }
}
