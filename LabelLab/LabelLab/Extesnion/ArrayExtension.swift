//
//  ArrayExtension.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/25.
//

extension Array where Element: Identifiable {
    mutating func replace(to element: Element) {
        guard let index = self.firstIndex(where: { value in
            value.id == element.id
        }) else {
            return
        }
        self[index] = element
    }

    mutating func delete(_ element: Element) {
        guard let index = self.firstIndex(where: { value in
            value.id == element.id
        }) else {
            return
        }
        self.remove(at: index)
    }
}
