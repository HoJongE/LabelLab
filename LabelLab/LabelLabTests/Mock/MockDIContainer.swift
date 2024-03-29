//
//  MockDIContainer.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/01.
//

@testable import LabelLab

enum MockDIContainerProvider {
    static func mockDIContainer(appState: AppState) -> DIContainer {
        let oAuthInteractor = MockOAuthInteractor(appState: appState)
        let uploadToGithubInteractor = RealUploadToGithubInteractor(appState: appState)
        let myTemplateListInteractor = RealMyTemplateListInteractor(appState: appState)
        let templateDetailInteractor = RealTemplateDetailInteractor(appState: appState)
        let labelListInteractor = RealLabelListInteractor(appState: appState)
        let inspirationInteractor = RealInspirationInteractor(appState: appState)

        let interactors = DIContainer.Interactors(oAuthInteractor: oAuthInteractor,
                                                  uploadToGithubInteractor: uploadToGithubInteractor,
                                                  myTemplateListInteractor: myTemplateListInteractor,
                                                  templateDetailInteractor: templateDetailInteractor,
                                                  labelListInteractor: labelListInteractor,
                                                  inspirationInteractor: inspirationInteractor)
        return DIContainer(interactors: interactors)
    }
}
