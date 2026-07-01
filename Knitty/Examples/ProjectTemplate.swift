//
//  ProjectTemplate.swift
//  Knitty
//
//  Created by Y. Khusanova on 01.07.26.
//

import Foundation

/// A starting point for a new project. `.blank` begins empty; the other cases
/// seed the project with ready-made parts and rows.
enum ProjectTemplate: CaseIterable, Identifiable {
    case blank
    case bananaSocks

    var id: Self { self }

    var displayName: String {
        switch self {
        case .blank: "Blank"
        case .bananaSocks: "Banana socks"
        }
    }

    /// Part specs used to seed a new project from this template.
    private var parts: [(String, [RowGroup])] {
        switch self {
        case .blank: []
        case .bananaSocks: [Project.bananaSockRight, Project.bananaSockLeft]
        }
    }

    func makeProject(name: String) -> Project {
        Project(name: name, projectParts: parts)
    }
}
