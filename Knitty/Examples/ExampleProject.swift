//
//  File.swift
//  Knitty
//
//  Created by Y. Khusanova on 02.02.26.
//


extension Project{
    static let bananaSockRight = ("Right sock", [SubPattern.bananaSockTop] + (0..<10).map {_ in SubPattern.bananaSockRightBody} + [SubPattern.bananaSockRightBottom])
    static let bananaSockLeft = ("Left sock", [SubPattern.bananaSockTop] + (0..<10).map {_ in SubPattern.bananaSockLeftBody} + [SubPattern.bananaSockLeftBottom])
    static let bananaSocks = Project(name: "Banana socks", projectParts: [bananaSockRight, bananaSockLeft])
}
