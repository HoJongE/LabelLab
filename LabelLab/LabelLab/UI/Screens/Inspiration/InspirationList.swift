//
//  InspirationList.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/17.
//

import SwiftUI

struct InspirationList: View {

    @EnvironmentObject private var appState: AppState
    @Environment(\.injected) private var diContainer: DIContainer
    @State private var isCopying: Event = .notRequested
    @State private var copyError: Error?
    @State private var message: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            tabName()
            title()
            divider()
            content()
        }
        .disabled(isCopying == .isLoading(last: nil))
        .padding()
        .maxSize(.topLeading)
        .onChange(of: isCopying, perform: {
            if let error = $0.error {
                copyError = error
            }
            switch isCopying {
            case .failed: isCopying = .notRequested
            case .loaded: message = "copy completed!"
            default: break
            }
        })
        .overlay(content: {
            if case .isLoading = isCopying {
                ZStack {
                    Color.black.opacity(0.7)
                    ProgressView()
                }
            }
        })
        .overlay {
            if let template = appState.routing.inspirationListRouting.template {
                InspirationTemplateDetail(template: template)
            }
        }
        .toast($message)
        .errorToast($copyError)
    }
}

// MARK: - Side Effects
private extension InspirationList {
    func requestTemplates(force reloading: Bool = false) {
        diContainer.interactors
            .inspirationInteractor
            .requestNextTemplates(query: .init(perPage: 10), force: reloading)
    }

    func copyTemplate(_ template: Template) {
        guard let user = appState.userData.userInfo.value else {
            isCopying = .failed(OAuthError.userInfoNotExist)
            return
        }
        Task(priority: .userInitiated) {
            await diContainer.interactors
                .inspirationInteractor
                .copyTemplate(template: template, to: String(user.id), isCopying: $isCopying)
        }
    }
}

// MARK: - Content
private extension InspirationList {
    @ViewBuilder
    func content() -> some View {
        switch appState.userData.templateList {
        case .notRequested:
            Text("")
                .onAppear {
                    requestTemplates()
                }
        case .isLoading, .loaded:
            loaded(appState.userData.templateList)
        case .failed(let error):
            failed(error: error)
        }
    }
}

// MARK: - Loaded
private extension InspirationList {
    @ViewBuilder
    func loaded(_ templates: Loadable<[Template]>) -> some View {
        VStack {
            if let templates = templates.value {
                list(templates)
            }
            if case .isLoading = templates {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

// MARK: - Failed
private extension InspirationList {
    func failed(error: Error) -> some View {
        VStack {
            Text("An error occur when load templates!\n\(error.localizedDescription)")
                .bold()
            DefaultButton(text: "try again", style: .primary) {
                requestTemplates()
            }
            .padding()
        }
        .maxSize(.center)
    }
}

// MARK: - emptyView
private extension InspirationList {
    func emptyView() -> some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                VStack {
                    Image("ic_flask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    Text("Ouhh.. it’s empty in here")
                        .font(.system(.title3)).bold()
                    Group {
                        Text("How about make your own template and share it!")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(Color.white80)
                }
                Spacer()
            }
            Spacer()
        }
    }
}

// MARK: - UI Components
private extension InspirationList {

    func reloadButton() -> some View {
        DefaultButton(text: "reload", style: .primary) {
            requestTemplates(force: true)
        }
    }
    func tabName() -> some View {
        HStack {
            Text("Inspirations")
                .bold()
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
                .padding(.bottom, 16)
            Spacer()
            reloadButton().padding(.trailing)
        }
    }
    func title() -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Explore other people`s templates")
                .bold()
                .font(.title)
            Spacer()
        }
    }

    func divider() -> some View {
        Rectangle()
            .fill(Color.white.opacity(0.1))
            .frame(maxWidth: .infinity)
            .frame(height: 1.5)
            .padding(.vertical, 16)
    }

    func list(_ templates: [Template], isLoading: Bool = false) -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 340))]) {
                ForEach(templates) { template in
                    cell(template)
                }
                Text("")
                    .onAppear {
                        requestTemplates()
                    }
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    func cell(_ template: Template) -> some View {
        InspirationTemplateCell(template: template, onClick: onCellClick(_:)) { _ in
            copyTemplate(template)
        }
    }

    func onCellClick(_ template: Template) {
        withAnimation(.easeInOut) {
            appState.routing.inspirationListRouting.template = template
        }
    }
}

// MARK: - Routing
extension InspirationList {
    struct Routing: Equatable {
        var template: Template?
    }
}
// MARK: - Preview
struct InspirationList_Previews: PreviewProvider {

    static func makePreview(_ inspirations: Loadable<[Template]> = .notRequested) -> some View {
        let userData: AppState.UserData = .init(templateList: inspirations)
        let appState: AppState = AppState(userData)
        return NavigationView {
            Sidebar()
            InspirationList()
        }
        .previewDisplayName(inspirations.previewDisplayName)
        .injectPreview(appState)
        .frame(width: 930, height: 500)
    }

    static var previews: some View {
        Group {
            makePreview(.notRequested)
            makePreview(.isLoading(last: Template.mockedData))
            makePreview(.failed(OAuthError.dataNotExist))
            makePreview(.loaded([]))
            makePreview(.loaded(Template.mockedData))
        }
    }
}
