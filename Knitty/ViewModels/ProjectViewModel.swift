//
//  PatternViewModel.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.01.26.
//

import Foundation

@Observable class ProjectViewModel {
    var currentProject: Project
    var currentRowNumber: Int
    var currentRow: Row
    var rowCount: Int{
        currentProject.projectParts[0].totalRowCounter
    }
    var isFinishedProjectPart: Bool {
        currentRowNumber > rowCount
    }
    
    init() {
        let currentRowNumber = UserDefaults.standard.integer(forKey: "rowNumber")
        var currentProject: Project
        var currentRow: Row
        do {
            guard let projectFileURL = Bundle.main.url(forResource: "banana-socks", withExtension: "json") else {
                throw DataError.fileNotFound
            }
            let projectData = try Data(contentsOf: projectFileURL)
            currentProject = try JSONDecoder().decode(Project.self, from: projectData)
        }
        catch {
            currentProject = Project.bananaSocks
        }
        
        currentRow = currentProject.getRow(indexRow: currentRowNumber, indexPart: 0) ?? Row(instructions: "Add a new row to the pattern.")
        
        self.currentRowNumber = currentRowNumber
        self.currentRow = currentRow
        self.currentProject = currentProject
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
