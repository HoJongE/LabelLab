//
//  BasicButton.swift
//  LabelLab
//
//  Created by Chanhee Jeong on 2022/08/29.
//

import SwiftUI

enum BasicButtonType {
    case primary // blue
    case secondary // gray
    var color: LinearGradient {
        switch self {
        case .primary:
            return LinearGradient(colors: [Color("4B91F7"), Color("367AF6")],
                                  startPoint: .top,
                                  endPoint: .bottom)
        case .secondary:
            return LinearGradient(colors: [Color("6E6D70"), Color("6E6D70")],
                                  startPoint: .top,
                                  endPoint: .bottom)
        }
    }
}

struct BasicButton: View {
    private let text: String
    private let type: BasicButtonType
    private let clicked: (() -> Void) /// use closure for callback

    init(text: String,
         type: BasicButtonType,
         clicked: @escaping () -> Void) {
        self.text = text
        self.type = type
        self.clicked = clicked
    }
    var body: some View {
        Button(action: clicked) {
            HStack {
                Text(text)
            }
            .font(.system(size: 13, weight: .medium))
            .contentShape(Rectangle())
            .padding(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 14))
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(type.color)
            )
        }
        .buttonStyle(.plain)
    }
}
 struct BasicButton_Previews: PreviewProvider {
     static var previews: some View {
         BasicButton(text: "버튼테스트", type: .primary) {
             // click event goes here
         }
     }
 }
