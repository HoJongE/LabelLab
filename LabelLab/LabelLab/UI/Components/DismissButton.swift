//
//  DismissButton.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/24.
//

import SwiftUI

struct DismissButton: View {
    @State private var isHover: Bool = false
    private let onClick: () -> Void

    init(_ onClick: @escaping () -> Void = {}) {
        self.onClick = onClick
    }

    var body: some View {
        Button {
            onClick()
        } label: {
            Circle()
                .fill(Color.red)
                .frame(width: 12)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .overlay(alignment: .center) {
                    if isHover {
                        Text(Image(systemName: "xmark"))
                            .fontWeight(.black)
                            .foregroundColor(.black.opacity(0.6))
                            .font(.system(size: 8))
                    } else {
                        EmptyView()
                    }
                }
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hover in
            isHover = hover
        }
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
    }
}
