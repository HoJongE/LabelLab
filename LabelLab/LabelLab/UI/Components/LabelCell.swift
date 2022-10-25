//
//  LabelCell.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/18.
//

import SwiftUI

struct LabelCell: View {

    private let label: Label
    private let selected: Bool
    private let onModifiy: ((Label) -> Void)?
    private let onDelete: ((Label) -> Void)?
    @State private var isHover: Bool = false
    @State private var isShowingDeletePopup: Bool = false

    init(label: Label,
         selected: Bool = false,
         onModify: ((Label) -> Void)? = nil,
         onDelete: ((Label) -> Void)? = nil) {
        self.label = label
        self.selected = selected
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
        .deleteAlert($isShowingDeletePopup, text: "Do you want to delete \(label.name)") {
            onDelete?(label)
        }
    }
}

// MARK: - UI Componenets
private extension LabelCell {

    @ViewBuilder
    func cellBackground() -> some View {
        if selected {
            RoundedRectangle(cornerRadius: 10).fill(isHover ? Color.cellHoverBackground : Color.cellBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.blue, lineWidth: 2, antialiased: true)
                }
        } else {
            RoundedRectangle(cornerRadius: 10).fill(isHover ? Color.cellHoverBackground : Color.cellBackground)
        }
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
            isShowingDeletePopup = true
        }
    }
}
#if DEBUG
struct LabelCell_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            LabelCell(label: Label.mockedData.first!, onModify: { _ in }, onDelete: { _ in })
                .padding()
                .previewDisplayName("Non selected cell")
            LabelCell(label: Label.mockedData.first!, selected: true)
                .padding()
                .previewDisplayName("Selected cell")
        }
    }
}
#endif
