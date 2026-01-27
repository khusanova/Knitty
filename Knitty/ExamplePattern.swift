//
//  ExamplePattern.swift
//  Knitty
//
//  Created by Y. Khusanova on 27.01.26.
//

import Foundation

extension Row{
    static let ribbing1x1 = ["k", "p"]
    static let ribbing2x2 = ["k", "k", "p", "p"]
    static let knit = ["k"]
    static let purl = ["p"]
}

extension Pattern{
    static let example = Pattern(baseRow: Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 42)), length: 47, name: "Example Pattern")
    static let bananaSockTop = Pattern(baseRow: Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 56), rowExtras: Dictionary(uniqueKeysWithValues: (1...4).map{ ($0*14, "end of needle")})), length: 15, name: "Banana Sock", patternURL: URL(filePath: "https://www.kotona.com/articles/banana-socks"))
    static let bananaSockKnitRow = Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 14), rowExtras: [14: "end of needle"]) +
    Row(stitches: Row.generateStitches(basePattern: Row.knit, n: 26), rowExtras: [14: "end of needle", 26: "end of needle"]) +
    Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 16), rowExtras: [16: "end of needle"])
    static let bananaSockPurlRow = Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 14), rowExtras: [14: "end of needle"]) +
    Row(stitches: Row.generateStitches(basePattern: Row.purl, n: 26), rowExtras: [14: "end of needle", 26: "end of needle"]) +
    Row(stitches: Row.generateStitches(basePattern: Row.ribbing2x2, n: 16), rowExtras: [16: "end of needle"])
    static let bananaSockBody = (0..<10).map{ _ in Pattern(baseRow: Pattern.bananaSockKnitRow, length: 5) + Pattern(baseRow: Pattern.bananaSockPurlRow, length: 5)}.reduce(bananaSockTop,+)
    static let rowDecreases = (7...14).reversed().map {Row(stitches: Row.generateStitches(basePattern: Row.knit, n: $0), rowExtras: [$0-3: "k2tog"]) +
        Row(stitches: Row.generateStitches(basePattern: Row.knit, n: $0), rowExtras: [2: "skp"]) +
        Row(stitches: Row.generateStitches(basePattern: Row.knit, n: $0), rowExtras: [$0-3: "k2tog"]) +
        Row(stitches: Row.generateStitches(basePattern: Row.knit, n: $0), rowExtras: [2: "skp"])}
    static let bananaSock = Pattern.bananaSockBody + Pattern(rows: rowDecreases)
}

