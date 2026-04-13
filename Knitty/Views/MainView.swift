//
//  MainView.swift
//  Knitty
//
//  Created by Y. Khusanova on 29.03.26.
//

import SwiftUI

struct MainView: View {
    let projectStorage = ProjectStorage()
    var savedProjects: [String] {
        projectStorage.savedProjectNames
    }

    var body: some View {
        NavigationStack {
            if savedProjects.isEmpty {
                Text("No saved projects yet.")
                    .navigationTitle("Knitty")
            } else {
                List(savedProjects, id: \.self) { projectName in
                    NavigationLink(projectName) {
                        ProjectView(projectName: projectName)
                    }
                }
                .navigationTitle("Knitty")
            }
        }
    }
}

#Preview {
    MainView()
}
