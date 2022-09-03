//
//  GithubRepAPI.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/03.
//

enum GithubRepAPI {
    case repositories(token: String)
}

extension GithubRepAPI: APICall {

    var path: String {
        switch self {
        case .repositories:
            return URLCollection.Github.GITHUB_GET_REPOSITORIES
        }
    }

    var method: String {
        switch self {
        case .repositories:
            return "get"
        }
    }

    var headers: Headers {
        switch self {
        case .repositories(token: let token):
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }

    var parameters: Parameters {
        switch self {
        case .repositories:
            return [
                "per_page": "100"
            ]
        }
    }

    var baseURL: String {
        switch self {
        case .repositories:
            return URLCollection.Github.GITHUB_API_BASE_URL
        }
    }

}
