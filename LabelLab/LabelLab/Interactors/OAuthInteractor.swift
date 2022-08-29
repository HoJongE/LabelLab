//
//  OAuthInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/29.
//

protocol OAuthInteractor {
    func openOAuthSite()
    func requestAccessToken() async
    func requestUserInfo() async
}

struct RealOAuthInteractor {
    private let oAuthService: OAuthService
    private let appState: AppState

    init(oAuthService: OAuthService = GithubOAuthService.shared, appState: AppState) {
        self.oAuthService = oAuthService
        self.appState = appState
    }

}

extension RealOAuthInteractor: OAuthInteractor {

    func openOAuthSite() {
        oAuthService.openOAuthSite()
    }

    func requestAccessToken() async {
        do {
            // TODO: Keychain 에 Access Token 저장해야 함
            let accessToken: AccessToken = try await oAuthService.requestAccessToken(with: "")
        } catch {
            appState.userData.userInfo = .failed(error)
        }
    }

    // TODO: Firebase 인증 후 UserInfo 요청해야함!
    func requestUserInfo() async {
        do {
            let userInfo: UserInfo = try await oAuthService.requestUserInfo()
            appState.userData.userInfo = .loaded(userInfo)
        } catch {
            appState.userData.userInfo = .failed(error)
        }
    }

}
