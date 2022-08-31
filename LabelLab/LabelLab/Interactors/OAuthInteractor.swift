//
//  OAuthInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/29.
//

import Foundation
import KeyChainWrapper

protocol OAuthInteractor {
    func openOAuthSite()
    func requestAccessToken(with authorizeCode: String) async
    func requestUserInfo() async
    func logout() async
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

    func requestAccessToken(with authorizeCode: String) async {
        do {
            let serviceName = try getServiceName()
            let accessToken: AccessToken = try await oAuthService.requestAccessToken(with: authorizeCode)

            try await PasswordKeychainManager(service: serviceName)
                .savePassword(accessToken, for: KeychainConst.accessToken)
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

    func logout() async {
        do {
            let serviceName = try getServiceName()
            try await PasswordKeychainManager(service: serviceName)
                .removePassword(for: KeychainConst.accessToken)
            try await oAuthService.logout()
            appState.userData.userInfo = .notRequested
        } catch {
            appState.userData.userInfo = .failed(error)
        }
    }

}

// MARK: - Implementation
private extension RealOAuthInteractor {
    func getServiceName() throws -> String {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            throw KeyChainError.unknownError(message: "키체인 저장 실패!")
        }
        return bundleIdentifier
    }
}
