//
//  MyTemplateDetail.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/12.
//

import SwiftUI

struct MyTemplateDetail: View {

    @EnvironmentObject private var appState: AppState
    @Environment(\.injected) private var diContainer: DIContainer
    private let template: Template
    @State private var labels: Loadable<[Label]>
    @State private var name: String
    @State private var description: String
    @State private var tags: [String]
    @State private var editLabelState: EditLabelState = .none

    init(labels: Loadable<[Label]> = .notRequested, template: Template) {
        self._labels = State(initialValue: labels)
        self.template = template
        self._name = State(initialValue: template.name)
        self._description = State(initialValue: template.templateDescription)
        self._tags = State(initialValue: template.tag)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton()
            HStack {
                VStack {
                    templateTitle(of: template)
                    templateDescription(of: template)
                }
                Spacer()
                addButton()
                    .padding()
            }
            templateTags(of: template)
            divider()
            editLabel()
            content()
        }
        .maxSize(.topLeading)
        .background(Color.detailBackground)
        .padding()
        .onTapGesture {
            NSApp.keyWindow?.makeFirstResponder(nil)
        }
    }
}

// MARK: - Tool bar content builder
private extension MyTemplateDetail {
    func addButton() -> some View {
        DefaultButton(text: "Add Label", style: .primary) {
            switchEditLabelState(.add)
        }
    }
}

private extension MyTemplateDetail {
    enum EditLabelState {
        case none
        case add
        case modify(Label)
    }
}

// MARK: - Side Effect
private extension MyTemplateDetail {
    func loadLabels() {
        Task(priority: .userInitiated) {
            await diContainer
                .interactors
                .labelListInteractor
                .requestLabels(of: template, to: $labels)
        }
    }

    func deleteLabel(label: Label) {
        Task(priority: .userInitiated) {
            await diContainer
                .interactors
                .labelListInteractor
                .deleteLabel(of: template, label, labels: $labels)
        }
    }

    func switchEditLabelState(_ state: EditLabelState) {
        withAnimation {
            self.editLabelState = state
        }
    }

    func closeEditLabel() {
        withAnimation {
            editLabelState = .none
        }
    }

    func updateTemplateName(to name: String) {
        diContainer.interactors
            .templateDetailInteractor
            .updateTemplateName(of: template, to: name) { _ in

            }
    }

    func updateTemplateDescription(to description: String) {
        diContainer.interactors
            .templateDetailInteractor
            .updateTemplateDescription(of: template, to: description) { _ in

            }
    }

    func addLabel(_ label: Label) {
        Task(priority: .userInitiated) {
            await diContainer.interactors
                .labelListInteractor
                .addLabel(to: template, label, labels: $labels)
        }
    }

    func modifyLabel(_ label: Label) {
        Task(priority: .userInitiated) {
            await diContainer.interactors
                .labelListInteractor
                .modifyLabel(of: template, label, labels: $labels)
        }
    }
}

extension AnyTransition {
    static var moveFromTopWithOpacity: AnyTransition {
        .asymmetric(insertion: .move(edge: .top).animation(.spring()).combined(with: .opacity.animation(.easeInOut.delay(0.1))), removal: .move(edge: .top).animation(.spring()).combined(with: .opacity))
    }
}

// MARK: - UI Components
private extension MyTemplateDetail {

    @ViewBuilder
    func editLabel() -> some View {
        switch editLabelState {
        case .none:
            EmptyView()
        case .add:
            EditLabel(labels: $labels, onClose: closeEditLabel, onDone: addLabel(_:))
                .transition(.moveFromTopWithOpacity)
        case .modify(let label):
            EditLabel(edit: label, labels: $labels, onClose: closeEditLabel, onDone: modifyLabel(_:))
                .transition(.moveFromTopWithOpacity)
        }
    }

    func backButton() -> some View {
        Button {
            appState.routing.myTemplateListRouting.template = nil
        } label: {
            Image(systemName: "chevron.left")
                .padding([.bottom, .trailing], 12)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    func templateTitle(of template: Template) -> some View {
        EditableText(text: $name, font: .largeTitle, fontWeight: .bold, hint: "Please enter your template name", max: 30) {
            updateTemplateName(to: $0)
        }
    }

    func templateDescription(of template: Template) -> some View {
        EditableText(text: $description, font: .title3, fontWeight: .regular, hint: "Please enter your template description", max: 100) {
            updateTemplateDescription(to: $0)
        }
        .foregroundColor(.white.opacity(0.7))
        .padding(.top, 7)
    }

    func templateTags(of template: Template) -> some View {
        HStack {
            ForEach(template.tag, id: \.self) { tag in
                Text("#\(tag)")
                    .fontWeight(.semibold)
            }
        }
        .padding(.top, 20)
    }

    func divider() -> some View {
        Rectangle()
            .fill(Color.white.opacity(0.1))
            .frame(maxWidth: .infinity)
            .frame(height: 1.5)
            .padding(.vertical, 16)
    }
}
// MARK: - Content
private extension MyTemplateDetail {

    @ViewBuilder
    func content() -> some View {
        switch labels {
        case .notRequested:
            notRequested()
        case .isLoading:
            isLoading()
        case .loaded(let labels):
            loaded(labels)
        case .failed(let error):
            errorIndicator(error)
        }
    }
}
// MARK: - is Loading
private extension MyTemplateDetail {
    func isLoading() -> some View {
        VStack {
            Text("label is loading...")
                .bold()
            ProgressView()
        }
        .maxSize(.center)
    }
}

// MARK: - Loaded
private extension MyTemplateDetail {
    func loaded(_ labels: [Label]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
                Section {
                    ForEach(labels) { label in
                        LabelCell(label: label, onModify: {
                            switchEditLabelState(.modify($0))
                        }, onDelete: deleteLabel(label:))
                            .padding(.vertical, 2)
                    }
                } header: {
                    labelListTitle(labels.count)
                }
            }
            .padding(.trailing)
        }
        .maxSize(.topLeading)
        .padding(.top)
    }

    func labelListTitle(_ count: Int) -> some View {
        Text("Label List (\(count))")
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.detailBackground)
    }
}

// MARK: - Error Indicator
private extension MyTemplateDetail {
    func errorIndicator(_ error: Error) -> some View {
        VStack {
            Text("Error occur when loading labels!")
                .bold()
            Text(error.localizedDescription)
            Button {
                loadLabels()
            } label: {
                Text("retry")
            }
        }
        .maxSize(.center)
    }
}

// MARK: - Not requested
private extension MyTemplateDetail {
    func notRequested() -> some View {
        Text("")
            .onAppear(perform: loadLabels)
    }
}

#if DEBUG
// MARK: - Preview
struct MyTemplateDetail_Previews: PreviewProvider {

    static func makePreview(_ labels: Loadable<[Label]>) -> some View {
        NavigationView {
            EmptyView()
            MyTemplateDetail(labels: labels, template: Template.mockedData.first!)
        }
        .frame(minWidth: 600, minHeight: 500)
        .previewDisplayName(labels.previewDisplayName)
        .injectPreview()
    }
    static var previews: some View {
        Group {
            makePreview(.notRequested)
            makePreview(.isLoading(last: nil))
            makePreview(.loaded(Label.mockedData))
            makePreview(.failed(OAuthError.userInfoNotExist))
        }
    }
}
#endif
