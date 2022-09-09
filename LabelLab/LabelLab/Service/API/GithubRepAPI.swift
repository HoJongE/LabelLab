//
//  GithubRepAPI.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/03.
//

enum GithubRepAPI {
    case repositories(token: String)
    case labels(token: String, of: GithubRepository)
    case deleteLabel(token: String, of: GithubRepository, label: Label)
    case createLabel(token: String, of: GithubRepository, label: Label)
}

extension GithubRepAPI: APICall {

    var path: String {
        switch self {
        case .repositories:
            return URLCollection.Github.GITHUB_GET_REPOSITORIES
        case .createLabel(_, let repository, _):
            return URLCollection.Github.GITHUB_CREATE_LABEL(of: repository)
        case .deleteLabel(_, let repository, let label):
            return URLCollection.Github.GITHUB_DELETE_LABEL(of: repository, label: label)
        case .labels(_, let repository):
            return URLCollection.Github.GITHUB_GET_LABELS(of: repository)
        }
    }

    var method: String {
        switch self {
        case .repositories: return "get"
        case .createLabel: return "post"
        case .deleteLabel: return "delete"
        case .labels: return "get"
        }
    }

    var headers: Headers {
        switch self {
        case .repositories(token: let token):
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(token)"
            ]
        case .createLabel(token: let token, _, _):
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(token)"
            ]
        case .deleteLabel(token: let token, _, _):
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(token)"
            ]
        case .labels(token: let token, _):
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
        case .createLabel:
            return [:]
        case .deleteLabel:
            return [:]
        case .labels:
            return [
                "per_page": "100"
            ]
        }
    }

    var baseURL: String {
        switch self {
        default: return URLCollection.Github.GITHUB_API_BASE_URL
        }
    }

}
