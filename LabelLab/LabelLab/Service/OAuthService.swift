//
//  OAuthService.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

import FirebaseAuth

typealias AccessToken = String

enum OAuthServiceError: Error {
    case dataNotExist
    case tokenNotExist
}

extension OAuthServiceError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .dataNotExist:
            return "에러가 발생했습니다."
        case .tokenNotExist:
            return "액세스 토큰을 발급받지 못했습니다."
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .dataNotExist:
            return "다시 요청해주세요."
        case .tokenNotExist:
            return "다시 요청해주세요."
        }
    }
}

protocol OAuthService {
    var session: URLSessionProtocol { get }
    func openOAuthSite()
    func requestAccessToken(with code: String) async throws -> AccessToken
    func requestUserInfo() async throws -> UserInfo
    func logout() async throws

}

final class GithubOAuthService {
    static let shared: GithubOAuthService = .init()
    let session: URLSessionProtocol

    init(_ session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

#if canImport(AppKit)

import AppKit

extension GithubOAuthService: OAuthService {
    func openOAuthSite() {
        guard let url = GithubAPI.authorize.url else { return }
        NSWorkspace.shared.open(url)
    }
}
#endif

extension GithubOAuthService {

    func requestAccessToken(with code: String) async throws -> AccessToken {
        let (data, _) = try await GithubAPI.accessToken(authorizeCode: code).request(with: session)
        let token = try parseDataToAccessToken(data)
        return token
    }

    func requestUserInfo() async throws -> UserInfo {
        return UserInfo.hojonge
    }

    func logout() async throws {
        try Auth.auth().signOut()
    }

}

private extension GithubOAuthService {

    func parseDataToAccessToken(_ data: Data) throws -> String {
        guard let json = try? JSONDecoder().decode([String: String].self, from: data) else { throw OAuthServiceError.dataNotExist }
        guard let token = json["access_token"] else { throw OAuthServiceError.tokenNotExist }
        return String(token)
    }

}
