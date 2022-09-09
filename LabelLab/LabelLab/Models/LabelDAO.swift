//
//  LabelDAO.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/08.
//

import Foundation

struct LabelDAO: Codable {
    let id: Int
    let name: String
    let description: String
    let color: String

    func toLabel() -> Label {
        Label(id: UUID().uuidString, name: name, labelDescription: description, hex: color)
    }
}
