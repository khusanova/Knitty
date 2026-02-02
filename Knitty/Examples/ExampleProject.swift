//
//  File.swift
//  Knitty
//
//  Created by Y. Khusanova on 02.02.26.
//


extension Project{
    static let bananaSockRightPatternIDs = [Pattern.bananaSockTop.id]
    + (0..<10).map {_ in Pattern.bananaSockRightBody.id}
    + [Pattern.bananaSockRightBottom.id]
    static let bananaSockRight = ProjectPart(name: "Right banana sock", patternOrder: bananaSockRightPatternIDs)
    static let bananaSockLeftPatternIDs = [Pattern.bananaSockTop.id]
    + (0..<10).map {_ in Pattern.bananaSockLeftBody.id}
    + [Pattern.bananaSockLeftBottom.id]
    static let bananaSockLeft = ProjectPart(name: "Left banana sock", patternOrder: bananaSockLeftPatternIDs)
    static let patternsForBananaSock = [Pattern.bananaSockTop.id: Pattern.bananaSockTop, Pattern.bananaSockRightBody.id: Pattern.bananaSockRightBody,
                                        Pattern.bananaSockLeftBody.id: Pattern.bananaSockLeftBody,
                                        Pattern.bananaSockRightBottom.id: Pattern.bananaSockRightBottom,
                                        Pattern.bananaSockLeftBottom.id: Pattern.bananaSockLeftBottom]
    static let bananaSocks = Project(name: "Banana socks", projectParts: [bananaSockRight, bananaSockLeft], patterns: patternsForBananaSock)
}
