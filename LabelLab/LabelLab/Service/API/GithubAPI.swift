//
//  GithubAPI.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

import Foundation

enum GithubAPI {
    case authorize
}

extension GithubAPI: APICall {

    var path: String {
        switch self {
        case .authorize:
            return URLCollection.Github.GITHUB_AUTHORIZE
        }
    }

    var method: String {
        switch self {
        case .authorize: return "get"
        }
    }

    var headers: Headers {
        switch self {
        case .authorize:
            return [:]
        }
    }

    var parameters: Parameters {
        switch self {
        case .authorize:
            return ["client_id": KeyStorage.GithubClientId,
                    "scope": "user, repo"]
        }
    }

    var baseURL: String {
        switch self {
        case .authorize:
            return URLCollection.Github.GITHUB_AUTHENTICATE_BASE_URL
        }
    }

}
