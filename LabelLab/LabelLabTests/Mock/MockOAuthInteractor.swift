//
//  MockOAuthInteractor.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/01.
//

@testable import LabelLab

struct MockOAuthInteractor: OAuthInteractor {

    private let appState: AppState

    init(appState: AppState) {
        self.appState = appState
    }

    func openOAuthSite() {
    }

    func requestAccessToken(with authorizeCode: String) async {
    }

    func requestUserInfo() async {
        appState.userData.userInfo = .loaded(UserInfo.hojonge)
    }

    func logout() async {
        appState.userData.userInfo = .notRequested
    }

}
