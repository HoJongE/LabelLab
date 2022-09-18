//
//  MyTemplateDetail.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/12.
//

import SwiftUI

struct MyTemplateDetail: View {

    @EnvironmentObject private var appState: AppState
    private let template: Template
    @State private var labels: Loadable<[Label]>

    init(labels: Loadable<[Label]> = .notRequested, template: Template) {
        self._labels = State(initialValue: labels)
        self.template = template
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            backButton()
            templateTitle(of: template)
            templateDescription(of: template)
            templateTags(of: template)
            divider()
            content()
        }
        .maxSize(.topLeading)
        .background(Color.detailBackground)
        .padding()
    }
}

// MARK: - Side Effect
private extension MyTemplateDetail {
    func loadLabels() {

    }

    func deleteLabel(label: Label) {

    }

    func modifyLabel(label: Label) {

    }
}

// MARK: - UI Components
private extension MyTemplateDetail {

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
        Text(template.name)
            .font(.largeTitle)
            .bold()
    }

    func templateDescription(of template: Template) -> some View {
        Text(template.templateDescription)
            .font(.body)
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
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(labels) { label in
                    LabelCell(label: label, onModify: modifyLabel(label:), onDelete: deleteLabel(label:))
                        .padding(.vertical, 2)
                }
            }
            .padding(.trailing)
        }
        .maxSize(.topLeading)
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
        EmptyView()
            .onAppear(perform: loadLabels)
    }
}

#if DEBUG
// MARK: - Preview
struct MyTemplateDetail_Previews: PreviewProvider {

    static func makePreview(_ labels: Loadable<[Label]>) -> some View {
        MyTemplateDetail(labels: labels, template: Template.mockedData.first!)
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
