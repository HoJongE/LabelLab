//
//  TemplateCell.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/18.
//

import SwiftUI

struct TemplateCell: View {
    private let template: Template
    private let onChangeOpen: (Bool) -> Void
    private let onDelete: (Template) -> Void

    @State private var isHover: Bool = false

    init(template: Template,
         onChangeOpen: @escaping (Bool) -> Void = { _ in },
         onDelete: @escaping (Template) -> Void = { _ in }) {
        self.template = template
        self.onChangeOpen = onChangeOpen
        self.onDelete = onDelete
    }

    var body: some View {
        VStack(alignment: .leading) {
            title(of: template)
            description(of: template)
            tagList
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .frame(height: 110, alignment: .topLeading)
        .padding()
        .background(cellBackground)
        .onHover { isHover = $0 }
        .padding(.bottom, 8)
        .overlay(alignment: .topTrailing, content: buttonOverlay)
    }

    @ViewBuilder
    private func title(of template: Template) -> some View {
        if template.isOpen {
            Text(template.name)
                .font(.headline)
        } else {
            Text("\(template.name)  \(Image(systemName: "lock.fill"))")
                .font(.headline)
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
            }
        }
        .padding(.top, 20)
    }

    private var cellBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(isHover ? Color.cellHoverBackground: .cellBackground)
    }
}

// MARK: 버튼모음
private extension TemplateCell {

    func deleteButton() -> some View {
        CircleButton(systemName: "trash") {
            onDelete(template)
        }
    }

    func changeOpenButton() -> some View {
        CircleButton(systemName: template.isOpen ? "lock.open.fill": "lock.fill") {
            onChangeOpen(!template.isOpen)
        }
    }

    func buttonOverlay() -> some View {
        HStack {
            if isHover {
                changeOpenButton()
                deleteButton()
            }
        }
        .padding()
    }
}

struct TemplateCell_Previews: PreviewProvider {
    static var previews: some View {
        TemplateCell(template: Template.mockedData.first!)
            .padding()
    }
}
