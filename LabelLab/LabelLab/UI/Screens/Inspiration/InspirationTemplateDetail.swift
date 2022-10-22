//
//  InspirationTemplateDetail.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/12.
//

import SwiftUI

struct InspirationTemplateDetail: View {

    @EnvironmentObject private var appState: AppState
    @Environment(\.injected) private var diContainer: DIContainer
    private let template: Template
    @State private var labels: Loadable<[Label]>
    @State private var name: String
    @State private var description: String
    @State private var tags: [String]
    @State private var error: Error?
    @State private var isCopying: Event = .notRequested
    @State private var message: String?

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
                VStack(alignment: .leading) {
                    templateTitle(of: template)
                    templateDescription(of: template)
                }
                Spacer()
                copyButton()
            }
            templateTags(of: template)
            divider()
            content()
        }
        .maxSize(.topLeading)
        .background(Color.detailBackground)
        .padding()
        .onChange(of: isCopying, perform: { newValue in
            switch newValue {
            case .failed(let error):
                self.error = error
                isCopying = .notRequested
            case .loaded: message = "copy completed!"
            default: break
            }
        })
        .disabled(isCopying == .isLoading(last: nil))
        .overlay {
            if case .isLoading = isCopying {
                ZStack {
                    Color.black.opacity(0.7)
                    ProgressView()
                }
            }
        }
        .toast($message)
        .errorToast($error)
    }
}

// MARK: - Tool bar content builder
private extension InspirationTemplateDetail {
    func copyButton() -> some View {
        DefaultButton(text: "Copy Label", style: .primary) {
            copyTemplate()
        }
        .keyboardShortcut("c") {
            copyTemplate()
        }
    }
}

// MARK: - Side Effect
private extension InspirationTemplateDetail {
    func loadLabels() {
        Task(priority: .userInitiated) {
            await diContainer
                .interactors
                .labelListInteractor
                .requestLabels(of: template, to: $labels)
        }
    }

    func copyTemplate() {
        guard let userInfo = appState.userData.userInfo.value else {
            error = OAuthError.userInfoNotExist
            return
        }
        Task(priority: .userInitiated) {
            await diContainer
                .interactors
                .inspirationInteractor
                .copyTemplate(template: template, to: String(userInfo.id), isCopying: $isCopying)
        }
    }
}

// MARK: - UI Components
private extension InspirationTemplateDetail {

    func backButton() -> some View {
        Button {
            appState.routing.inspirationListRouting.template = nil
        } label: {
            Image(systemName: "chevron.left")
                .padding([.bottom, .trailing], 12)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    func templateTitle(of template: Template) -> some View {
        Text(name)
            .font(.largeTitle)
            .fontWeight(.bold)
    }

    func templateDescription(of template: Template) -> some View {
        Text(description)
            .font(.title3)
            .fontWeight(.regular)
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
private extension InspirationTemplateDetail {

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
private extension InspirationTemplateDetail {
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
private extension InspirationTemplateDetail {
    func loaded(_ labels: [Label]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
                Section {
                    ForEach(labels) { label in
                        cell(label)
                    }
                } header: {
                    labelListTitle(labels.count)
                }
            }
            .padding(.trailing)
        }
        .maxSize(.topLeading)
        .toolbar {
            ToolbarItemGroup(placement: .automatic) {
                Spacer()
                Button {
                    appState.routing.inspirationTemplateDetailRouting.isShowingRepositoryList = true
                } label: {
                    Text("\(Image(systemName: "square.and.arrow.up")) Upload to Github")
                        .padding()
                }
                .keyboardShortcut("u") {
                    appState.routing.inspirationTemplateDetailRouting.isShowingRepositoryList = true
                }
            }
        }
        .sheet(isPresented: $appState.routing.inspirationTemplateDetailRouting.isShowingRepositoryList) {
            RepositoryList(labels: labels, templateName: template.name)
        }
        .padding(.top)
    }

    func cell(_ label: Label) -> some View {
        LabelCell(label: label,
                  selected: false,
                  onModify: nil,
                  onDelete: nil)
            .padding(.vertical, 2)
    }

    func labelListTitle(_ count: Int) -> some View {
        Text("Label List (\(count))")
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.detailBackground)
    }
}

// MARK: - Error Indicator
private extension InspirationTemplateDetail {
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
private extension InspirationTemplateDetail {
    func notRequested() -> some View {
        Text("")
            .onAppear(perform: loadLabels)
    }
}

// MARK: - Routing
extension InspirationTemplateDetail {
    struct Routing: Equatable {
        var isShowingRepositoryList: Bool = false
    }
}

#if DEBUG
// MARK: - Preview
struct InspirationTemplateDetail_Previews: PreviewProvider {

    static func makePreview(_ labels: Loadable<[Label]>) -> some View {
        NavigationView {
            EmptyView()
            InspirationTemplateDetail(labels: labels, template: Template.mockedData.first!)
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
