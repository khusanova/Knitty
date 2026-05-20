//
//  ExampleRowGroup.swift
//  Knitty
//
//  Created by Y. Khusanova on 27.01.26.
//

import Foundation

extension RowGroup {
    static var bananaSockTop: RowGroup {
        RowGroup(rows: (0..<15).map { _ in Row(instructions: "k2p2 x 14") })
    }

    static var bananaSockRightBody: RowGroup {
        RowGroup(
            rows: (0..<5).map { _ in Row(instructions: "k2p2 x 7, p2, k26") }
                + (0..<5).map { _ in Row(instructions: "k2p2 x 7, p2, p26") }
        )
    }

    static var bananaSockRightBottom: RowGroup {
        RowGroup(
            rows: (0..<2).map { _ in Row(instructions: "k56") } + [
                Row(instructions: "k1 PM k22 k2tog k1 k2tog k1 PM k1 skp k1 skp k21"),
                Row(instructions: "k1 M k1 skp k20 k2tog k1 M k1 skp k20 k2tog"),
                Row(instructions: "k1 M k18 k2tog k1 k2tog k1 M k1 skp k1 skp k17"),
                Row(instructions: "k1 M k1 skp k16 k2tog k1 M k1 skp k16 k2tog"),
                Row(instructions: "k1 M k14 k2tog k1 k2tog k1 M k1 skp k1 skp k13"),
                Row(instructions: "k1 M k1 skp k12 k2tog k1 M k1 skp k12 k2tog"),
                Row(instructions: "k1 M k10 k2tog k1 k2tog k1 M k1 skp k1 skp k9"),
                Row(instructions: "k1 M k1 skp k8 k2tog k1 M k1 skp k8 k2tog"),
                Row(instructions: "k1 M k6 k2tog k1 k2tog k1 M k1 skp k1 skp k5"),
            ]
        )
    }

    static var bananaSockLeftBody: RowGroup {
        RowGroup(
            rows: (0..<5).map { _ in Row(instructions: "k26, k2p2 x 7, p2") }
                + (0..<5).map { _ in Row(instructions: "p26, k2p2 x 7, p2") }
        )
    }

    static var bananaSockLeftBottom: RowGroup {
        RowGroup(
            rows: (0..<2).map { _ in Row(instructions: "k56") } + [
                Row(instructions: "k22 k2tog k1 k2tog k1 PM k1 skp k1 skp k21 M k1"),
                Row(instructions: "k1 skp k20 k2tog k1 M k1 skp k20 k2tog M K1"),
                Row(instructions: "k18 k2tog k1 k2tog k1 M k1 skp k1 skp k17 M k1"),
                Row(instructions: "k1 skp k16 k2tog k1 M k1 skp k16 k2tog M k1"),
                Row(instructions: "k14 k2tog k1 k2tog k1 M k1 skp k1 skp k13 M k1"),
                Row(instructions: "k1 skp k12 k2tog k1 M k1 skp k12 k2tog M k1"),
                Row(instructions: "k10 k2tog k1 k2tog k1 M k1 skp k1 skp k9 M k1"),
                Row(instructions: "k1 skp k8 k2tog k1 M k1 skp k8 k2tog M k1"),
                Row(instructions: "k6 k2tog k1 k2tog k1 M k1 skp k1 skp k5 M k1"),
            ]
        )
    }
}
