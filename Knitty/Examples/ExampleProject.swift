//
//  File.swift
//  Knitty
//
//  Created by Y. Khusanova on 02.02.26.
//


extension Project{
    static let bananaSockRight = ("Right sock", [Pattern.bananaSockTop] + (0..<10).map {_ in Pattern.bananaSockRightBody} + [Pattern.bananaSockRightBottom])
    static let bananaSockLeft = ("Left sock", [Pattern.bananaSockTop] + (0..<10).map {_ in Pattern.bananaSockLeftBody} + [Pattern.bananaSockLeftBottom])
    static let bananaSocks = Project(name: "Banana socks", projectParts: [bananaSockRight, bananaSockLeft])
}
