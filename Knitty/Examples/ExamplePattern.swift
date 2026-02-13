//
//  ExamplePattern.swift
//  Knitty
//
//  Created by Y. Khusanova on 27.01.26.
//

import Foundation

extension Pattern{
    static let bananaSockTop = Pattern(baseRow: Row(instructions: "k2p2 x 14"), length: 15)
    static let bananaSockRightBody = Pattern(baseRow: Row(instructions: "k2p2 x 7, p2, k26"), length: 5) + Pattern(baseRow: Row(instructions: "k2p2 x 7, p2, p26"), length: 5)
    static let bananaSockRightBottom = Pattern(baseRow: Row(instructions: "k56"), length: 2)
    + Pattern(rows: [Row(instructions: "k1 PM k22 k2tog k1 k2tog k1 PM k1 skp k1 skp k21"), Row(instructions: "k1 M k1 skp k20 k2tog k1 M k1 skp k20 k2tog"),
                     Row(instructions: "k1 M k18 k2tog k1 k2tog k1 M k1 skp k1 skp k17"), Row(instructions: "k1 M k1 skp k16 k2tog k1 M k1 skp k16 k2tog"),
                     Row(instructions: "k1 M k14 k2tog k1 k2tog k1 M k1 skp k1 skp k13"), Row(instructions: "k1 M k1 skp k12 k2tog k1 M k1 skp k12 k2tog"),
                     Row(instructions: "k1 M k10 k2tog k1 k2tog k1 M k1 skp k1 skp k9"), Row(instructions: "k1 M k1 skp k8 k2tog k1 M k1 skp k8 k2tog"),
                     Row(instructions: "k1 M k6 k2tog k1 k2tog k1 M k1 skp k1 skp k5")])
    
    static let bananaSockLeftBody = Pattern(baseRow: Row(instructions: "k26, k2p2 x 7, p2"), length: 5) + Pattern(baseRow: Row(instructions: "p26, k2p2 x 7, p2"), length: 5)
    static let bananaSockLeftBottom = Pattern(baseRow: Row(instructions: "k56"), length: 2)
    + Pattern(rows: [Row(instructions: "k22 k2tog k1 k2tog k1 PM k1 skp k1 skp k21 M k1"), Row(instructions: "k1 skp k20 k2tog k1 M k1 skp k20 k2tog M K1"),
                     Row(instructions: "k18 k2tog k1 k2tog k1 M k1 skp k1 skp k17 M k1"), Row(instructions: "k1 skp k16 k2tog k1 M k1 skp k16 k2tog M k1"),
                     Row(instructions: "k14 k2tog k1 k2tog k1 M k1 skp k1 skp k13 M k1"), Row(instructions: "k1 skp k12 k2tog k1 M k1 skp k12 k2tog M k1"),
                     Row(instructions: "k10 k2tog k1 k2tog k1 M k1 skp k1 skp k9 M k1"), Row(instructions: "k1 skp k8 k2tog k1 M k1 skp k8 k2tog M k1"),
                     Row(instructions: "k6 k2tog k1 k2tog k1 M k1 skp k1 skp k5 M k1")])
}
