//
//  ViewExtension.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/18.
//

import SwiftUI

extension View {
    func maxSize(_ alignment: Alignment = .center) -> some View {
        frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}

extension TextField {
    func maxLength(max length: Int, text: Binding<String>) -> some View {
        self.modifier(MaxLengthModifier(max: length, text: text))
    }
}

private struct MaxLengthModifier: ViewModifier {
    private let maxLength: Int
    @Binding private var text: String

    init(max length: Int,
         text: Binding<String>) {
        self.maxLength = length
        self._text = text
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: text) { changedText in
                if changedText.count > maxLength {
                    text = String(changedText.dropLast())
                }
            }
    }
}
