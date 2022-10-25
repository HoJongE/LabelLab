//
//  FAQItem.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/22.
//

import SwiftUI

struct FAQItem<Content: View>: View {

    private let icon: Image
    private let itemName: String
    private let content: () -> Content
    @State private var isFolded: Bool = true

    init(icon: Image,
         itemName: String,
         content: @escaping () -> Content) {
        self.icon = icon
        self.itemName = itemName
        self.content = content
    }

    var body: some View {
        VStack(spacing: 0) {
            title()
                .zIndex(1)
            foldableContent()
                .opacity(isFolded ? 0: 1)
                .zIndex(0)
        }
    }
}

// MARK: - Side Effects
private extension FAQItem {
    func toggleFold() {
        withAnimation(.easeInOut) {
            isFolded.toggle()
        }
    }
}
// MARK: - UI Componenets
private extension FAQItem {

    func title() -> some View {
        Button(action: toggleFold) {
            HStack {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                    .foregroundColor(isFolded ? .primaryBlue: Color.white)
                Text(itemName)
                    .font(.headline)
                    .bold()
                    .padding()
                Spacer()
                Image(systemName: "chevron.down")
                    .padding()
                    .contentShape(Rectangle())
                    .rotationEffect(.degrees(isFolded ? 180: 0))
            }
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 8).fill(isFolded ? Color.cellBackground: Color.primaryBlue))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    func foldableContent() -> some View {
        content()
            .frame(height: isFolded ? 0: nil)
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(Color.cellBackground.opacity(0.7)))
    }
}
#if DEBUG
struct FAQItem_Previews: PreviewProvider {
    static var previews: some View {
        FAQItem(icon: Image(systemName: "xmark"), itemName: "톡킹온더쓋") {
            Text("content 입니다.")
        }
    }
}
#endif
