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
    func openOAuthSite()
    func requestAccessToken(with code: String) async throws -> AccessToken
}

final class GithubOAuthService {
    static let shared: GithubOAuthService = .init()

    private init() {}
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
        let (data, _) = try await GithubAPI.accessToken(authorizeCode: code).request()
        let token = try parseDataToAccessToken(data)
        return token
    }

}

private extension GithubOAuthService {

    func parseDataToAccessToken(_ data: Data) throws -> String {
        guard let data2String = String(data: data, encoding: .utf8) else { throw OAuthServiceError.dataNotExist }
        guard let token = data2String.split(separator: "&").first?.split(separator: "=").last else { throw OAuthServiceError.tokenNotExist }
        return String(token)
    }

}
