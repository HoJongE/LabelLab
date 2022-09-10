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

        init(oAuthInteractor: OAuthInteractor,
             uploadToGithubInteractor: UploadToGithubInteractor) {
            self.oAuthInteractor = oAuthInteractor
            self.uploadToGithubInteractor = uploadToGithubInteractor
        }
    }
}

// MARK: - For previews
#if DEBUG
extension DIContainer.Interactors {
    static var preview: DIContainer.Interactors {
        .init(oAuthInteractor: RealOAuthInteractor(appState: AppState.preview),
              uploadToGithubInteractor: RealUploadToGithubInteractor(appState: AppState.preview))
    }
}
#endif
