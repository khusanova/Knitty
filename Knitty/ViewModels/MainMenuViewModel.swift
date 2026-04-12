//
//  MainMenuViewModel.swift
//  Knitty
//
//  Created by Y. Khusanova on 12.04.26.
//

import Foundation

@Observable class MainMenuViewModel {
    
    static let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func savedProjectNames() -> [String] {
        guard let files = try? FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil) else {
            return []
        }
        return files
            .filter { $0.pathExtension == "json" }
            .map { $0.deletingPathExtension().lastPathComponent }
    }
}
