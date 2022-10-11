//
//  LabelCell.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/18.
//

import SwiftUI

struct LabelCell: View {

    // TODO: 편집 모드 만들어야함...
    private let label: Label
    private let onModifiy: ((Label) -> Void)?
    private let onDelete: ((Label) -> Void)?

    @State private var isHover: Bool = false

    init(label: Label,
         onModify: ((Label) -> Void)? = nil,
         onDelete: ((Label) -> Void)? = nil) {
        self.label = label
        self.onModifiy = onModify
        self.onDelete = onDelete
    }

    var body: some View {
        HStack(alignment: .center) {
            name(of: label)
                .frame(width: 170, alignment: .leading)
            description(of: label)
            Spacer()

            if onModifiy != nil && isHover {
                modifyButton()
            }

            if onDelete != nil && isHover {
                deleteButton()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(cellBackground())
        .onHover { isHover = $0 }
    }
}

// MARK: - UI Componenets
private extension LabelCell {

    func cellBackground() -> some View {
        RoundedRectangle(cornerRadius: 10).fill(isHover ? Color.cellHoverBackground : Color.cellBackground)
    }

    func name(of label: Label) -> some View {
        Text(label.name)
            .bold()
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .background(RoundedRectangle(cornerRadius: 50).fill(Color(label.hex)))
    }

    func description(of label: Label) -> some View {
        Text(label.labelDescription)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    func modifyButton() -> some View {
        CircleButton(systemName: "pencil") {
            onModifiy?(label)
        }
    }

    func deleteButton() -> some View {
        CircleButton(systemName: "trash") {
            onDelete?(label)
        }
    }
}

struct LabelCell_Previews: PreviewProvider {
    static var previews: some View {
        LabelCell(label: Label.mockedData.first!, onModify: { _ in }, onDelete: { _ in })
            .padding()
    }
}
