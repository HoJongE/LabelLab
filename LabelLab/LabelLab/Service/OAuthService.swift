//
//  OAuthService.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

import FirebaseAuth

typealias AccessToken = String

enum OAuthError: Error {
    case dataNotExist
    case tokenNotExist
    case userInfoNotExist
}

extension OAuthError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .dataNotExist:
            return "에러가 발생했습니다."
        case .tokenNotExist:
            return "액세스 토큰을 발급받지 못했습니다."
        case .userInfoNotExist:
            return "유저 정보가 없습니다."
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .dataNotExist:
            return "다시 요청해주세요."
        case .tokenNotExist:
            return "다시 요청해주세요."
        case .userInfoNotExist:
            return "다시 로그인을 시도해주세요."
        }
    }
}

protocol OAuthService {
    var session: URLSessionProtocol { get }
    var accessTokenManager: AccessTokenManager { get }
    func openOAuthSite()
    func requestAccessToken(with code: String) async throws -> AccessToken
    func requestUserInfo() async throws -> UserInfo
    func logout() async throws
}

extension OAuthService {
    var token: String? {
        get async throws {
            try await accessTokenManager.requestAccessToken()
        }
    }
}

final class GithubOAuthService {
    static let shared: GithubOAuthService = .init()
    let session: URLSessionProtocol
    private let auth: Auth = Auth.auth()
    let accessTokenManager: AccessTokenManager

    init(_ session: URLSessionProtocol = URLSession.shared, accessTokenManager: AccessTokenManager = RealAccessTokenManager()) {
        self.session = session
        self.accessTokenManager = accessTokenManager
    }
}

#if canImport(AppKit)

import AppKit

extension GithubOAuthService: OAuthService {
    func openOAuthSite() {
        guard let url = GithubAuthAPI.authorize.url else { return }
        NSWorkspace.shared.open(url)
    }
}
#endif

extension GithubOAuthService {

    func requestAccessToken(with code: String) async throws -> AccessToken {
        let (data, _) = try await GithubAuthAPI.accessToken(authorizeCode: code).request(with: session)
        let token = try parseDataToAccessToken(data)
        try await accessTokenManager.saveAccessToken(token)
        return token
    }

    func requestUserInfo() async throws -> UserInfo {
        // 먼저 Firebase Auth 에 인증되있지 않다면, Github accessToken 으로 인증을 시도함
        guard let token = try await token else {
            throw OAuthError.tokenNotExist
        }
        if !ProcessInfo().isRunningTests {
            if auth.currentUser == nil {
                let githubAuthProvider = GitHubAuthProvider.credential(withToken: token)
                try await auth.signIn(with: githubAuthProvider)
            }
        }
        // 인증을 완료했으면, Access Token 으로 Github User Info 를 불러온다.
        let (data, _) = try await GithubAuthAPI.getUser(accessToken: token).request(with: session)
        return try parseDataToUserInfo(data)
    }

    func logout() async throws {
        try await accessTokenManager.removeAccessToken()
        try auth.signOut()
    }

}

private extension GithubOAuthService {

    func parseDataToAccessToken(_ data: Data) throws -> String {
        guard let json = try? JSONDecoder().decode([String: String].self, from: data) else { throw OAuthError.dataNotExist }
        guard let token = json["access_token"] else { throw OAuthError.tokenNotExist }
        return String(token)
    }

    func parseDataToUserInfo(_ data: Data) throws -> UserInfo {
        guard let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) else {
            throw OAuthError.userInfoNotExist
        }
        return userInfo
    }

}
