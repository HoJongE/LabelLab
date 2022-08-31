//
//  MockedService.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/08/29.
//

@testable import LabelLab

final class MockOAuthService: OAuthService {
    let session: LabelLab.URLSessionProtocol

    init(_ session: LabelLab.URLSessionProtocol) {
        self.session = session
    }

    func openOAuthSite() {

    }

    func requestAccessToken(with code: String) async throws -> LabelLab.AccessToken {
        ConstantData.accessToken
    }

    func requestUserInfo() async throws -> LabelLab.UserInfo {
        UserInfo.hojonge
    }

    func logout() async throws {
    }
}
