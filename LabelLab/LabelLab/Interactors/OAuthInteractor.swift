//
//  OAuthInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/29.
//

import Foundation

protocol OAuthInteractor {
    func openOAuthSite()
    func requestAccessToken(with authorizeCode: String) async
    func requestUserInfo() async
    func logout() async
}

struct RealOAuthInteractor {
    private let oAuthService: OAuthService
    private let appState: AppState
    private let accessTokenManager: AccessTokenManager

    init(oAuthService: OAuthService = GithubOAuthService.shared, appState: AppState, accessTokenManager: AccessTokenManager = RealAccessTokenManager()) {
        self.oAuthService = oAuthService
        self.appState = appState
        self.accessTokenManager = accessTokenManager
    }

}

extension RealOAuthInteractor: OAuthInteractor {

    func openOAuthSite() {
        oAuthService.openOAuthSite()
    }

    @MainActor func requestAccessToken(with authorizeCode: String) async {
        do {
            appState.userData.userInfo = .isLoading(last: nil)
            _ = try await oAuthService.requestAccessToken(with: authorizeCode)
        } catch {
            appState.userData.userInfo = .failed(error)
        }
    }

    @MainActor func requestUserInfo() async {
        do {
            let userInfo: UserInfo = try await oAuthService.requestUserInfo()
            appState.userData.userInfo = .loaded(userInfo)
        } catch {
            appState.userData.userInfo = .failed(error)
        }
    }

    @MainActor func logout() async {
        do {
            try await oAuthService.logout()
            appState.userData.userInfo = .notRequested
        } catch {
            appState.userData.userInfo = .failed(error)
        }
    }

}
