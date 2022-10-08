//
//  Interactors.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

extension DIContainer {

    struct Interactors {

        let oAuthInteractor: OAuthInteractor
        let uploadToGithubInteractor: UploadToGithubInteractor
        let myTemplateListInteractor: MyTemplateListInteractor
        let templateDetailInteractor: TemplateDetailInteractor

        init(oAuthInteractor: OAuthInteractor,
             uploadToGithubInteractor: UploadToGithubInteractor,
             myTemplateListInteractor: MyTemplateListInteractor,
             templateDetailInteractor: TemplateDetailInteractor) {
            self.oAuthInteractor = oAuthInteractor
            self.uploadToGithubInteractor = uploadToGithubInteractor
            self.myTemplateListInteractor = myTemplateListInteractor
            self.templateDetailInteractor = templateDetailInteractor
        }
    }
}

// MARK: - For previews
#if DEBUG
extension DIContainer.Interactors {
    static var preview: DIContainer.Interactors {
        .init(oAuthInteractor: RealOAuthInteractor(appState: AppState.preview),
              uploadToGithubInteractor: RealUploadToGithubInteractor(appState: AppState.preview),
              myTemplateListInteractor: RealMyTemplateListInteractor(appState: AppState.preview),
              templateDetailInteractor: RealTemplateDetailInteractor(appState: AppState.preview))
    }
}
#endif
