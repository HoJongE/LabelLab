//
//  DIGenerator.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/25.
//

struct DIGenerator {

    let appState: AppState

    private (set) lazy var diContainer: DIContainer = {
        let interactors = self.generateInteractors(appState)
        return DIContainer(interactors: interactors)
    }()

    private (set) lazy var deepLinkHandler: DeepLinkHandler = {
        RealDeepLinkHandler(diContainer, appState)
    }()

    init(_ userData: AppState.UserData = .init(),
         _ routing: AppState.ViewRouting = .init()) {
        self.appState = AppState(userData, routing)
        self.diContainer = DIContainer(interactors: generateInteractors(appState))
    }

    private func generateInteractors(_ appState: AppState) -> DIContainer.Interactors {

        let oAuthInteractor: OAuthInteractor = RealOAuthInteractor(appState: appState)
        let uploadToGithubInteractor: UploadToGithubInteractor = RealUploadToGithubInteractor(appState: appState)
        let myTemplateListInteractor: MyTemplateListInteractor = RealMyTemplateListInteractor(appState: appState)
        let templateDetailInteractor: TemplateDetailInteractor = RealTemplateDetailInteractor(appState: appState)

        return DIContainer.Interactors(oAuthInteractor: oAuthInteractor,
                                       uploadToGithubInteractor: uploadToGithubInteractor,
                                       myTemplateListInteractor: myTemplateListInteractor,
                                       templateDetailInteractor: templateDetailInteractor)
    }
}
