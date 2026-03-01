//
//  ProjectViewModel.swift
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
    
    init() {
        let defaultProjectName = UserDefaults.standard.string(forKey: "projectName") ?? "banana-socks"
        self.project = ProjectViewModel.loadProject(projectName: defaultProjectName)
        self.projectName = defaultProjectName
        let partIndex = UserDefaults.standard.object(forKey: "currentPartIndex") as? Int
        let rowNumber = UserDefaults.standard.object(forKey: "currentRowNumber") as? Int
        if let partIndex, let rowNumber {
            self.currentPosition = (partIndex, rowNumber)
        }
    }
    
    func startKnitting(projectPartIndex: Int) {
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
    
    func saveProject() -> Bool {
        let fileURL = ProjectViewModel.documentsURL.appendingPathComponent(self.projectName + ".json")
        do {
            let projectData = try JSONEncoder().encode(self.project)
            try projectData.write(to: fileURL)
            return true
        }
        catch {
            return false
        }
    }
    
    static let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
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
