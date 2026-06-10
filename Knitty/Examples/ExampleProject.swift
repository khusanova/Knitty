//
//  File.swift
//  Knitty
//
//  Created by Y. Khusanova on 02.02.26.
//


extension Project{
    static var bananaSockRight: (String, [RowGroup]) {
        ("Right sock", [RowGroup.bananaSockTop] + (0..<10).map {_ in RowGroup.bananaSockRightBody} + [RowGroup.bananaSockRightBottom])
    }
    static var bananaSockLeft: (String, [RowGroup]) {
        ("Left sock", [RowGroup.bananaSockTop] + (0..<10).map {_ in RowGroup.bananaSockLeftBody} + [RowGroup.bananaSockLeftBottom])
    }
    static var bananaSocks: Project {
        Project(name: "Banana socks", projectParts: [bananaSockRight, bananaSockLeft])
    }
}
