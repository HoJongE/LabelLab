//
//  GithubService.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/03.
//

import Foundation

protocol GithubService {
    var session: URLSessionProtocol { get }
    func requestRepositories(with token: String) async throws -> [GithubRepository]
}

final class RealGithubService {
    static let shared: GithubService = RealGithubService()
    let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

// MARK: - Protocol 구현부
extension RealGithubService: GithubService {
    func requestRepositories(with token: String) async throws -> [GithubRepository] {
        let (data, _) = try await GithubRepAPI.repositories(token: token).request(with: session)
        let repositories: [GithubRepository] = try JSONDecoder().decode([GithubRepository].self, from: data)

        return repositories
    }
}
