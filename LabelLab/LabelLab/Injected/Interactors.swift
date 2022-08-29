//
//  Interactors.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

extension DIContainer {

    struct Interactors {
        let oAuthInteractor: OAuthInteractor

        init(oAuthInteractor: OAuthInteractor) {
            self.oAuthInteractor = oAuthInteractor
        }
    }
}

// MARK: - For previews
#if DEBUG
extension DIContainer.Interactors {
    static var preview: DIContainer.Interactors {
        .init(oAuthInteractor: RealOAuthInteractor(appState: AppState.preview))
    }
}
#endif
