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

    func errorToast(_ error: Binding<Error?>) -> some View {
        modifier(ErrorToast(error))
    }
}

extension TextField {
    func maxLength(max length: Int, showIndicator: Bool = false, text: Binding<String>) -> some View {
        self.modifier(MaxLengthModifier(max: length, showIndicator: showIndicator, text: text))
    }
}

private struct MaxLengthModifier: ViewModifier {
    private let maxLength: Int
    private let showIndicator: Bool
    @Binding private var text: String

    init(max length: Int,
         showIndicator: Bool,
         text: Binding<String>) {
        self.maxLength = length
        self._text = text
        self.showIndicator = showIndicator
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .trailing) {
            content
            if showIndicator {
                Text("\(text.count)/\(maxLength)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.trailing, 4)
            }
        }
        .onChange(of: text) { changedText in
            if changedText.count > maxLength {
                text = String(changedText.dropLast())
            }
        }
    }
}

struct ErrorToast: ViewModifier {
    @Binding private var error: Error?

    init(_ error: Binding<Error?>) {
        self._error = error
    }

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if let error {
                errorToast(error.localizedDescription)
                    .transition(.opacity.animation(.easeInOut))
                    .zIndex(3)
                    .onAppear(perform: dismiss)
            }
        }
    }

    private func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            error = nil
        }
    }

    private func errorToast(_ errorMessage: String) -> some View {
        Text("\(Image(systemName: "xmark.octagon.fill"))  \(errorMessage)")
            .lineLimit(1)
            .font(.title3)
            .frame(minWidth: 120, alignment: .center)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.red.opacity(0.8)))
            .padding(.bottom, 48)
    }
}
