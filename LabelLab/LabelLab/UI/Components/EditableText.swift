//
//  EditableText.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/25.
//

import SwiftUI

struct EditableText: View {

    private let font: Font
    private let fontWeight: Font.Weight
    private let onFinish: (String) -> Void
    private let hint: String
    @Binding private var text: String
    @State private var isFocused: Bool = false

    init(text: Binding<String>,
         font: Font = .body,
         fontWeight: Font.Weight = .regular,
         hint: String = "",
         onFinish: @escaping (String) -> Void = { _ in }) {
        self._text = text
        self.font = font
        self.onFinish = onFinish
        self.fontWeight = fontWeight
        self.hint = hint
    }

    var body: some View {
        TextField(text: $text, prompt: prompt) {

        }
        .textFieldStyle(.plain)
        .font(font.weight(fontWeight))
        .onSubmit {
            DispatchQueue.main.async {
                NSApp.keyWindow?.makeFirstResponder(nil)
                onFinish(text)
            }
        }
    }

    private var prompt: Text {
        Text(hint)
            .font(font.weight(fontWeight))
    }
}

struct EditableText_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditableText(text: .constant("Hello World"), font: .largeTitle, hint: "헬로 월드 ㅎㅎ")
                .previewDisplayName("플레이스홀더없음")
            EditableText(text: .constant(""), font: .largeTitle, hint: "플레이스홀더 ㅎㅎ")
                .previewDisplayName("플레이스홀더 잇음")
        }
    }
}
