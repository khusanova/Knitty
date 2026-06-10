//
//  PreviewSupport.swift
//  Knitty
//
//  Created by Y. Khusanova on 10.06.26.
//

import Foundation
import SwiftData

/// In-memory SwiftData container seeded with the example project, for previews.
@MainActor
enum PreviewSupport {
    static let container: ModelContainer = {
        let container = try! ModelContainer(
            for: Project.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        container.mainContext.insert(Project.bananaSocks)
        try? container.mainContext.save()
        return container
    }()

    static var project: Project {
        try! container.mainContext.fetch(FetchDescriptor<Project>()).first!
    }
}
