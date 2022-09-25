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

    @State private var isDeleting: Loadable<Void> = .notRequested
    @State private var isChangingVisibility: Loadable<Void> = .notRequested

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

// MARK: - emptyView
private extension MyTemplateList {
    func emptyView() -> some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                VStack {
                    Image("ic_flask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    Text("Ouhh.. it’s empty in here")
                        .font(.system(.title3)).bold()
                    Group {
                        Text("Once you make a label collection,")
                        Text("you’ll see them here")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(Color.white80)
                }
            }
            Spacer()
        }
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
        Task(priority: .userInitiated) {
              await diContainer.interactors.myTemplateListInteractor.loadTemplates()
        }
    }

    func openAuthWindow() {
        appState.routing.rootRouting.isShowingLoginPopup = true
    }

    func addTemplate() {
        guard let userInfo = appState.userData.userInfo.value else {
            return
        }
        let template: Template = Template(id: UUID().uuidString, name: "My Template", templateDescription: "", makerId: String(userInfo.id), copyCount: 0, tag: [], isOpen: false)
        Task(priority: .userInitiated) {
            await diContainer.interactors
                .myTemplateListInteractor
                .addTemplate(template: template)
        }

        appState.routing.myTemplateListRouting.template = template
    }

    func changeVisibility(of template: Template) {
        Task(priority: .userInitiated) {
            await diContainer
                .interactors
                .myTemplateListInteractor
                .changeTemplateVisibility(of: template, isChanging: $isChangingVisibility)
        }
    }

    func deleteTemplate(_ template: Template) {
        Task(priority: .userInitiated) {
            await diContainer
                .interactors
                .myTemplateListInteractor
                .deleteTemplate(template, $isDeleting)
        }
    }
}

// MARK: - Not requested
private extension MyTemplateList {
    func notRequested() -> some View {
        Text("")
            .onChange(of: appState.userData.userInfo) { newValue in
                switch newValue {
                case .notRequested, .isLoading:
                    break
                case .loaded, .failed:
                    loadTemplates()
                }
            }
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
    func loaded(templates: [Template]) -> some View {
        HStack {
            if templates.isEmpty {
                Spacer()
                emptyView()
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 340))]) {
                        ForEach(templates) { template in
                            cell(template)
                        }
                    }
                    .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    func cell(_ template: Template) -> some View {
        TemplateCell(template: template) { template in
            onCellClick(template)
        } onChangeVisibility: { template in
            changeVisibility(of: template)
        } onDelete: { template in
            deleteTemplate(template)
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
            makePreview(.loaded([]))
            makePreview(.failed(OAuthError.dataNotExist))
            makePreview(.needAuthentication)
        }
    }
}
#endif
