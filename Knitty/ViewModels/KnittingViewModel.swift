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
    var errorMessage: String?
    var rowCounter: Int  { project.projectParts[partIndex].rowCounter }
    var isFinished: Bool { project.projectParts[partIndex].isFinished }
    var currentRow: Row? { project.getRow(indexRow: rowCounter, indexPart: partIndex)}
    

    private var project: Project {
        get { projectVM.project }
        set { projectVM.project = newValue }
    }

    init(projectVM: ProjectViewModel, partIndex: Int) {
        self.projectVM = projectVM
        self.partIndex = partIndex
        projectVM.save()
    }

    func unravel() {
        do {
            try project.unravel(partIndex: self.partIndex)
            projectVM.save()
        } catch ProjectProgressError.partIndexOutOfRange {
            self.errorMessage = "Something went wrong. This project part should not exist."
        } catch ProjectProgressError.rowIndexOutOfRange {
            self.errorMessage = "You have not yet started knitting."
        } catch {
            self.errorMessage = "Something went wrong."
        }
    }

    func knitRow() {
        do {
            try project.knit(partIndex: self.partIndex)
            projectVM.save()
        } catch ProjectProgressError.partIndexOutOfRange {
            self.errorMessage = "Something went wrong. This project part should not exist."
        } catch ProjectProgressError.rowIndexOutOfRange {
            self.errorMessage = "You have not yet started knitting."
        } catch {
            self.errorMessage = "Something went wrong."
        }
    }
}
