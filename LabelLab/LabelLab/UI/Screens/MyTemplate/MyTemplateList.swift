//
//  MyTemplateList.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/18.
//

import SwiftUI

struct MyTemplateList: View {

    @EnvironmentObject private var appState: AppState
    @Environment(\.injected) private var diContainer: DIContainer

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            tabName()
            title()
            divider()
            content()
        }
        .padding()
        .maxSize(.topLeading)
        .overlay {
            if let template = appState.routing.myTemplateListRouting.template {
                MyTemplateDetail(template: template)
                    .transition(.opacity.animation(.easeInOut(duration: 0.25)))
            }
        }
    }
}

// MARK: - UI Components
private extension MyTemplateList {

    func tabName() -> some View {
        Text("Issue Label Maker")
            .bold()
            .font(.title3)
            .foregroundColor(.white.opacity(0.8))
            .padding(.bottom, 16)
    }
    func title() -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Your Label Collection")
                .bold()
                .font(.title)
            Spacer()
            addTemplateButton()
        }
    }

    func divider() -> some View {
        Rectangle()
            .fill(Color.white.opacity(0.1))
            .frame(maxWidth: .infinity)
            .frame(height: 1.5)
            .padding(.vertical, 16)
    }

    func addTemplateButton() -> some View {
        DefaultButton(text: "New Template", style: .primary, onClick: addTemplate)
            .disabled(appState.userData.myTemplateList.value == nil)
    }
}

// MARK: - Content
private extension MyTemplateList {
    @ViewBuilder
    func content() -> some View {
        switch appState.userData.myTemplateList {
        case .notRequested:
            notRequested()
        case .isLoading:
            loading()
        case .loaded(let templates):
            loaded(templates: templates)
        case .failed(let error):
            failed(error: error)
        case .needAuthentication:
            authenticationRequired()
        }
    }
}

// MARK: - Side Effects
private extension MyTemplateList {

    func loadTemplates() {

    }

    func openAuthWindow() {
        appState.routing.rootRouting.isShowingLoginPopup = true
    }

    func addTemplate() {

    }
}

// MARK: - Not requested
private extension MyTemplateList {
    func notRequested() -> some View {
        EmptyView()
            .onAppear(perform: loadTemplates)
    }
}

// MARK: - Loading
private extension MyTemplateList {
    func loading() -> some View {
        VStack {
            Text("Loading my templates...")
                .fontWeight(.semibold)
            ProgressView()
        }
        .maxSize(.center)
    }
}

// MARK: - Loaded
private extension MyTemplateList {

    var gridColumn: [GridItem] {
        [
            GridItem(.adaptive(minimum: 260, maximum: 380), spacing: 16, alignment: .center),
            GridItem(.adaptive(minimum: 280, maximum: 350), spacing: 16, alignment: .center)
        ]
    }

    func loaded(templates: [Template]) -> some View {
        ScrollView {
            LazyVGrid(columns: gridColumn) {
                ForEach(templates) { template in
                    TemplateCell(template: template, onClick: onCellClick(_:))
                }
            }
        }
    }

    func onCellClick(_ template: Template) {
        appState.routing.myTemplateListRouting.template = template
    }
}

// MARK: - Failed
private extension MyTemplateList {
    func failed(error: Error) -> some View {
        VStack {
            Text("An error occur when load templates!\(error.localizedDescription)")
                .bold()
            DefaultButton(text: "try again", style: .primary) {
                loadTemplates()
            }
            .padding()
        }
        .maxSize(.center)
    }
}

// MARK: - Authentication Required
private extension MyTemplateList {
    func authenticationRequired() -> some View {
        VStack {
            Text("You need authentication to continue!")
                .bold()
            DefaultButton(text: "try again", style: .primary) {
                loadTemplates()
            }
            .padding()
        }
        .maxSize(.center)
        .onAppear(perform: openAuthWindow)
    }
}

// MARK: - routing
extension MyTemplateList {
    struct Routing: Equatable {
        var template: Template?
    }
}

// MARK: - Preview
#if DEBUG
struct MyTemplateList_Previews: PreviewProvider {

    static func makePreview(_ templates: AuthenticationRequiredLoadable<[Template]>) -> some View {
        let userData = AppState.UserData(myTemplateList: templates)
        let appState: AppState = .init(userData)
        return NavigationView {
            Sidebar()
            MyTemplateList()
        }
        .previewDisplayName(templates.previewDisplayName)
        .injectPreview(appState)
        .frame(width: 930, height: 500)
    }
    static var previews: some View {
        Group {
            makePreview(.notRequested)
            makePreview(.isLoading(last: nil))
            makePreview(.loaded(Template.mockedData))
            makePreview(.failed(OAuthError.dataNotExist))
            makePreview(.needAuthentication)
        }
    }
}
#endif
