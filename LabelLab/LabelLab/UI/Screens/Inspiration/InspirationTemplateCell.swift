//
//  InspirationTemplateCell.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/17.
//

import SwiftUI

struct InspirationTemplateCell: View {
    private let template: Template
    private let onClick: (Template) -> Void
    private let onCopy: (Template) -> Void
    @State private var isHover: Bool = false
    @State private var isShowingDeletePopup: Bool = false

    init(template: Template,
         onClick: @escaping (Template) -> Void = { _ in },
         onCopy: @escaping (Template) -> Void = { _ in }) {
        self.onClick = onClick
        self.template = template
        self.onCopy = onCopy
    }

    var body: some View {
        VStack(alignment: .leading) {
            title(of: template)
            description(of: template)
            tagList
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: 100, alignment: .topLeading)
        .padding(EdgeInsets(top: 20, leading: 20, bottom: 17, trailing: 15))
        .background(cellBackground)
        .onHover { isHover = $0 }
        .onTapGesture {
            onClick(template)
        }
        .overlay(alignment: .topTrailing, content: buttonOverlay)
    }

    @ViewBuilder
    private func title(of template: Template) -> some View {
        HStack(alignment: .top) {
            Text(template.name)
                .font(.headline).bold()
            if !template.isOpen {
                Image("ic_lock_plain")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
        }
    }

    private func description(of template: Template) -> some View {
        Text(template.templateDescription)
            .padding(.top, 12)
            .multilineTextAlignment(.leading)
    }

    private var tagList: some View {
        HStack {
            ForEach(template.tag, id: \.self) { tag in
                Text("#\(tag)")
                    .font(.footnote).bold()
            }
            Spacer()
            Text("copy count: \(template.copyCount)")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.top, 20)
    }

    private var cellBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(isHover ? Color.cellHoverBackground: .cellBackground)
    }
}

// MARK: 버튼모음
private extension InspirationTemplateCell {

    func copyButton() -> some View {
        CustomImageButton(imageName: "ic_copy", width: 24, height: 24) {
            onCopy(template)
        }
    }

    func buttonOverlay() -> some View {
        HStack {
            if isHover {
                copyButton()
            }
        }
        .padding()
    }
}

// MARK: - Preview
#if DEBUG
struct InspirationTemplateCell_Previews: PreviewProvider {
    static var previews: some View {
        InspirationTemplateCell(template: .mockedData.first!)
    }
}
#endif
