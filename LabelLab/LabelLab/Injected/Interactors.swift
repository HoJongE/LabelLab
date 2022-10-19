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
        let labelListInteractor: LabelListInteractor
        let inspirationInteractor: InspirationInteractor

        init(oAuthInteractor: OAuthInteractor,
             uploadToGithubInteractor: UploadToGithubInteractor,
             myTemplateListInteractor: MyTemplateListInteractor,
             templateDetailInteractor: TemplateDetailInteractor,
             labelListInteractor: LabelListInteractor,
             inspirationInteractor: InspirationInteractor) {
            self.oAuthInteractor = oAuthInteractor
            self.uploadToGithubInteractor = uploadToGithubInteractor
            self.myTemplateListInteractor = myTemplateListInteractor
            self.templateDetailInteractor = templateDetailInteractor
            self.labelListInteractor = labelListInteractor
            self.inspirationInteractor = inspirationInteractor
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
              templateDetailInteractor: RealTemplateDetailInteractor(appState: AppState.preview),
              labelListInteractor: RealLabelListInteractor(appState: AppState.preview),
              inspirationInteractor: RealInspirationInteractor(appState: AppState.preview))
    }
}
#endif
