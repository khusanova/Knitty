//
//  KnittingViewModel.swift
//  Knitty
//
//  Created by Y. Khusanova on 12.04.26.
//

import Foundation

@Observable class KnittingViewModel {
    let projectVM: ProjectViewModel
    let partIndex: Int
    var isFinished: Bool
    var currentPosition: (partIndex: Int, rowNumber: Int)? {
        didSet {
            if let position = currentPosition {
                UserDefaults.standard.set(position.partIndex, forKey: "currentPartIndex")
                UserDefaults.standard.set(position.rowNumber, forKey: "currentRowNumber")
            } else {
                UserDefaults.standard.removeObject(forKey: "currentPartIndex")
                UserDefaults.standard.removeObject(forKey: "currentRowNumber")
            }
        }
    }
    var currentRow: Row?

    private var project: Project {
        get { projectVM.project }
        set { projectVM.project = newValue }
    }

    init(projectVM: ProjectViewModel, partIndex: Int) {
        self.projectVM = projectVM
        self.partIndex = partIndex

        let part = projectVM.project.projectParts[partIndex]
        self.isFinished = part.isFinished
        if !part.isFinished {
            let rowNumber = part.rowCounter
            self.currentPosition = (partIndex, rowNumber)
            self.currentRow = projectVM.project.getRow(indexRow: rowNumber, indexPart: partIndex)
                ?? Row(instructions: "This row does not exist.")
        }
        projectVM.save()
    }

    func unravel() {
        guard var (partIndex, rowNumber) = currentPosition, rowNumber > 0 else { return }
        guard let row = project.getRow(indexRow: rowNumber - 1, indexPart: partIndex) else { return }
        rowNumber -= 1
        self.currentRow = row
        self.currentPosition = (partIndex, rowNumber)
        commitProgress()
    }

    func knitRow() {
        guard var (partIndex, rowNumber) = currentPosition else { return }
        if rowNumber + 1 == project.totalRowCount(of: partIndex) {
            self.isFinished = true
        }
        guard let row = project.getRow(indexRow: rowNumber + 1, indexPart: partIndex) else { return }
        rowNumber += 1
        self.currentRow = row
        self.currentPosition = (partIndex, rowNumber)
        commitProgress()
    }

    private func commitProgress() {
        guard let (partIndex, rowNumber) = currentPosition else { return }
        project.addProgressOnProjectPart(at: rowNumber, for: partIndex)
        projectVM.save()
    }
}
//let partIndex = UserDefaults.standard.object(forKey: "currentPartIndex") as? Int
//let rowNumber = UserDefaults.standard.object(forKey: "currentRowNumber") as? Int
//if let partIndex, let rowNumber {
//    self.currentPosition = (partIndex, rowNumber)
//}
