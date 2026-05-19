//
//  File.swift
//  Knitty
//
//  Created by Y. Khusanova on 02.02.26.
//


extension Project{
    static let bananaSockRight = ("Right sock", [RowGroup.bananaSockTop] + (0..<10).map {_ in RowGroup.bananaSockRightBody} + [RowGroup.bananaSockRightBottom])
    static let bananaSockLeft = ("Left sock", [RowGroup.bananaSockTop] + (0..<10).map {_ in RowGroup.bananaSockLeftBody} + [RowGroup.bananaSockLeftBottom])
    static let bananaSocks = Project(name: "Banana socks", projectParts: [bananaSockRight, bananaSockLeft])
}
