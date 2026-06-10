//
//  PreviewSupport.swift
//  Knitty
//
//  Created by Y. Khusanova on 10.06.26.
//

import Foundation
import SwiftData

extension ProjectStore {
    /// A store backed by an in-memory container, seeded with the example project.
    @MainActor
    static func preview() -> ProjectStore {
        let container = try! ModelContainer(
            for: Project.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let store = ProjectStore(context: container.mainContext)
        try? store.saveProject(Project.bananaSocks)
        return store
    }
}
