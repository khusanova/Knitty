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
//    var rowCounter: Int? {
//        currentProject.projectParts[0].totalRowCounter
//    }
//    var count: Int? {
//        currentProject.totalRowCount(of: currentProjectPart)
//    }
    
    init() {
        //let currentRowNumber = UserDefaults.standard.integer(forKey: "rowNumber")
        //var project: Project
        //var currentRow: Row
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
        
        //currentRow = currentProject.getRow(indexRow: currentRowNumber, indexPart: 0) ?? Row(instructions: "Add a new row to the pattern.")
        
        //self.currentRowNumber = currentRowNumber
        //self.currentRow = currentRow
        //self.currentProject = currentProject
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
        if rowNumber > 0 {
            self.currentRowNumber = rowNumber - 1
            currentRow = project.getRow(indexRow: rowNumber, indexPart: index) ?? Row(instructions: "This row does not exist.")
        }
    }
    
    func knitRow() {
        guard let rowNumber = currentRowNumber else {
            return
        }
        guard let index = projectPartIndex else {
            return
        }
        if rowNumber  < project.totalRowCount(of: index){
            self.currentRowNumber = rowNumber + 1
            currentRow = project.getRow(indexRow: rowNumber, indexPart: index) ?? Row(instructions: "This row does not exist.")
        }
    }
}

/*
func loadProject(){
    
    
}

func completeRow(unravel: Bool = false) {
    
}

func changeRow(goToNext: Bool = true) {
    if goToNext{
        guard displayedRow < currentProject.totalRowCount(projectPart: currentProjectPart) else {
            return
        }
        displayedRow += 1
    }
    else{
        guard displayedRow > 0 else {
            return
        }
        displayedRow -= 1
    }
}

func goToCurrentRow(){
    displayedRow = currentRow
}

func chooseProjectPart() {
    
}
*/
