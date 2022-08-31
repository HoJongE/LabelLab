//
//  GithubAPI.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

enum GithubAPI {
    case authorize
    case accessToken(authorizeCode: String)
}

extension GithubAPI: APICall {

    var path: String {
        switch self {
        case .authorize:
            return URLCollection.Github.GITHUB_AUTHORIZE
        case .accessToken:
            return URLCollection.Github.GITHUB_ACCESS_TOKEN
        }
    }

    var method: String {
        switch self {
        case .authorize: return "get"
        case .accessToken: return "post"
        }
    }

    var headers: Headers {
        switch self {
        case .authorize:
            return [:]
        case .accessToken:
            return ["Accept": "application/json"]
        }
    }

    var parameters: Parameters {
        switch self {
        case .authorize:
            return ["client_id": KeyStorage.GithubClientId,
                    "scope": "user, repo"]
        case .accessToken(authorizeCode: let code):
            return ["code": code,
                    "client_id": KeyStorage.GithubClientId,
                    "client_secret": KeyStorage.GithubClientSecret]
        }
    }

    var baseURL: String {
        switch self {
        case .authorize:
            return URLCollection.Github.GITHUB_AUTHENTICATE_BASE_URL
        case .accessToken:
            return URLCollection.Github.GITHUB_AUTHENTICATE_BASE_URL
        }
    }

}
