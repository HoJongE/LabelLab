//
//  PrimaryButton.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/18.
//

import SwiftUI

enum DefaultButtonStyle {
    case `default`
    case primary
}

struct DefaultButton: View {

    private let text: String
    private let style: DefaultButtonStyle
    private let onClick: () -> Void

    init(text: String, style: DefaultButtonStyle = .default, onClick: @escaping () -> Void = { }) {
        self.text = text
        self.style = style
        self.onClick = onClick
    }

    var body: some View {
        Button(action: onClick) {
            Text(text)
                .fontWeight(.medium)
                .contentShape(Rectangle())
                .padding(EdgeInsets(top: 3, leading: 14, bottom: 3, trailing: 14))
                .background(buttonBackground)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var buttonBackground: some View {
        switch style {
        case .default:
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.defaultButtonBackground)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.5))
                        .offset(x: 0, y: -0.26)
                }
        case .primary:
            RoundedRectangle(cornerRadius: 6)
                .fill(primaryButtonGradient)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.white.opacity(0.5))
                        .offset(x: 0, y: -0.26)
                }
        }
    }

    private var primaryButtonGradient: LinearGradient {
        LinearGradient(colors: [Color("4B91F7"), Color("367AF6")], startPoint: .top, endPoint: .bottom)
    }
}

struct DefaultButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DefaultButton(text: "Finish")
                .previewDisplayName("default button")
            DefaultButton(text: "Finish", style: .primary)
                .previewDisplayName("primary Button")
        }
        .padding()
    }
}
