//
//  MockedService.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/08/29.
//

@testable import LabelLab

final class MockOAuthService: OAuthService {
    let session: LabelLab.URLSessionProtocol
    let accessTokenManager: AccessTokenManager

    init(_ session: LabelLab.URLSessionProtocol, accessTokenManager: AccessTokenManager = MockAccessTokenManager()) {
        self.session = session
        self.accessTokenManager = accessTokenManager
    }

    func openOAuthSite() {

    }

    func requestAccessToken(with code: String) async throws -> LabelLab.AccessToken {
        let token = ConstantData.accessToken
        try await accessTokenManager.saveAccessToken(token)
        return token
    }

    func requestUserInfo() async throws -> LabelLab.UserInfo {
        UserInfo.hojonge
    }

    func logout() async throws {
        try await accessTokenManager.removeAccessToken()
    }
}
