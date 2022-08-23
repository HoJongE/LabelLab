//
//  Label.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

import Foundation

/// Github 라벨을 나타냄
struct Label: Codable, Identifiable {
    let id: String // Label 의 id
    let name: String // Label 이름
    let labelDescription: String // Label 설명
    let hex: String // Color hex 값

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case labelDescription = "description"
        case hex = "color"
    }
}

extension Label: Equatable {
    static func == (lhs: Label, rhs: Label) -> Bool {
        lhs.id == rhs.id
    }
}

extension Label: CustomStringConvertible {
    var description: String {
        "라벨 이름: \(name) 설명: \(labelDescription) 라벨 색상: \(color)"
    }
}

#if canImport(SwiftUI)
import SwiftUI

extension Label {
    var color: Color {
        Color(hex)
    }
}

#endif
