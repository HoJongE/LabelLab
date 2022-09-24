//
//  EncodableExtension.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/24.
//

import Foundation

extension Encodable {
    func encode() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
