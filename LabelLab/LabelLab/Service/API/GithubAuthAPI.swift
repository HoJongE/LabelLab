//
//  GithubAPI.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

enum GithubAuthAPI {
    case authorize
    case accessToken(authorizeCode: String)
    case getUser(accessToken: String)
}

extension GithubAuthAPI: APICall {

    var path: String {
        switch self {
        case .authorize:
            return URLCollection.Github.GITHUB_AUTHORIZE
        case .accessToken:
            return URLCollection.Github.GITHUB_ACCESS_TOKEN
        case .getUser:
            return URLCollection.Github.GITHUB_GET_AUTHETICATED_USER
        }
    }

    var method: String {
        switch self {
        case .authorize: return "get"
        case .accessToken: return "post"
        case .getUser: return "get"
        }
    }

    var headers: Headers {
        switch self {
        case .authorize:
            return [:]
        case .accessToken:
            return ["Accept": "application/json"]
        case .getUser(accessToken: let token):
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(token)"
            ]
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
        case .getUser:
            return [:]
        }
    }

    var baseURL: String {
        switch self {
        case .authorize:
            return URLCollection.Github.GITHUB_AUTHENTICATE_BASE_URL
        case .accessToken:
            return URLCollection.Github.GITHUB_AUTHENTICATE_BASE_URL
        case .getUser:
            return URLCollection.Github.GITHUB_API_BASE_URL
        }
    }

}
