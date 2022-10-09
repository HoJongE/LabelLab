//
//  AddLabel.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/09.
//

import SwiftUI

struct EditLabel: View {
    @State private var labelName: String
    @State private var labelDescription: String
    @State private var color: Color
    private let isEditMode: Bool

    init() {
        self._labelName = State(initialValue: "")
        self._labelDescription = State(initialValue: "")
        self.isEditMode = false
        self._color = State(initialValue: Color.green)
    }

    init(edit label: Label) {
        self._labelName = State(initialValue: label.name)
        self._labelDescription = State(initialValue: label.labelDescription)
        self._color = State(initialValue: Color(label.hex))
        self.isEditMode = true
    }

    var body: some View {
        VStack(alignment: .leading) {
            title()
            content()
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

// MARK: - Side Effects
private extension EditLabel {
    func resetContent() {
        labelName = ""
        labelDescription = ""
    }

    func editLabel() {

    }

    func addLabel() {

    }
}

// MARK: - UI Components
private extension EditLabel {

    func title() -> some View {
        Text(isEditMode ? "Edit Label": "Add Label")
            .font(.headline)
    }

    func resetButton() -> some View {
        DefaultButton(text: "Reset", style: .default, onClick: resetContent)
    }

    func createButton() -> some View {
        DefaultButton(text: isEditMode ? "Edit": "Create", style: .primary, onClick: isEditMode ? editLabel: addLabel)
    }

    func buttons() -> some View {
        HStack {
            resetButton()
            createButton()
        }
    }

    func roundedBackground() -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.cellBackground)
    }

    func nameTextField() -> some View {
        TextField("Label Name", text: $labelName)
            .maxLength(max: 100, text: $labelName)
            .textFieldStyle(.roundedBorder)
            .font(.headline.weight(.medium))
    }

    func descriptionTextField() -> some View {
        TextField("Description about this label", text: $labelDescription)
            .maxLength(max: 100, text: $labelDescription)
            .textFieldStyle(.roundedBorder)
            .font(.headline.weight(.medium))
    }

    func labelPreview() -> some View {
        Text(labelName)
            .bold()
            .frame(minWidth: 40)
            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .background(RoundedRectangle(cornerRadius: 50).fill(color))
    }

    func hexText() -> some View {
        Text("#" + (color.hex ?? "unknown color"))
    }

    func content() -> some View {
        VStack {
            HStack(alignment: .center) {
                labelPreview()
                Spacer()
                buttons()
            }
            .padding(.bottom)

            HStack {
                nameTextField()
                ColorPicker(selection: $color, supportsOpacity: false) {
                    EmptyView()
                }
                hexText()
            }
            descriptionTextField()
        }
        .padding()
        .background(roundedBackground())
    }
}

struct EditLabel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditLabel()
                .previewDisplayName("Add mode")
            EditLabel(edit: Label.mockedData.first!)
                .previewDisplayName("Edit mode")
        }
        .padding()
    }
}
