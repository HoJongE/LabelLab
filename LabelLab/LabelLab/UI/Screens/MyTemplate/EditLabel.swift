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
    @Binding private var labels: Loadable<[Label]>
    private let label: Label?
    private let isEditMode: Bool
    private let onClose: () -> Void
    private let onDone: (Label) -> Void

    init(labels: LoadableSubject<[Label]>,
         onClose: @escaping () -> Void = { },
         onDone: @escaping (Label) -> Void = { _ in }) {
        self._labelName = State(initialValue: "")
        self._labelDescription = State(initialValue: "")
        self.isEditMode = false
        self._color = State(initialValue: Color.green)
        self._labels = labels
        self.onClose = onClose
        self.onDone = onDone
        self.label = nil
    }

    init(edit label: Label,
         labels: LoadableSubject<[Label]>,
         onClose: @escaping () -> Void = { },
         onDone: @escaping (Label) -> Void = { _ in }) {
        self._labelName = State(initialValue: label.name)
        self._labelDescription = State(initialValue: label.labelDescription)
        self._color = State(initialValue: Color(label.hex))
        self.isEditMode = true
        self._labels = labels
        self.onClose = onClose
        self.onDone = onDone
        self.label = label
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                title()
                Spacer()
                closeButton()
            }
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
}

// MARK: - UI Components
private extension EditLabel {

    func title() -> some View {
        Text(isEditMode ? "Edit Label": "Add Label")
            .font(.headline)
    }

    func closeButton() -> some View {
        Button(action: onClose) {
            Image(systemName: "xmark")
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }

    func resetButton() -> some View {
        DefaultButton(text: "Reset", style: .default, onClick: resetContent)
    }

    func createButton() -> some View {
        DefaultButton(text: isEditMode ? "Edit": "Create", style: .primary) {
            if let label, let hex = color.hex {
                let modifiedLabel: Label = Label(id: label.id, name: labelName, labelDescription: labelDescription, hex: hex)
                onDone(modifiedLabel)
            } else if let hex = color.hex {
                let labelToAdd: Label = Label(id: UUID().uuidString, name: labelName, labelDescription: labelDescription, hex: hex)
                onDone(labelToAdd)
            }
        }
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
            .maxLength(max: 50, showIndicator: true, text: $labelName)
            .textFieldStyle(.roundedBorder)
            .font(.headline.weight(.medium))
    }

    func descriptionTextField() -> some View {
        TextField("Description about this label", text: $labelDescription)
            .maxLength(max: 100, showIndicator: true, text: $labelDescription)
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
            EditLabel(labels: .constant(.loaded([])))
                .previewDisplayName("Add mode")
            EditLabel(edit: Label.mockedData.first!, labels: .constant(.loaded([])))
                .previewDisplayName("Edit mode")
        }
        .padding()
    }
}
