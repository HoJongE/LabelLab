//
//  GithubService.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/03.
//

import Foundation

protocol GithubService {
    var session: URLSessionProtocol { get }
    var accessTokenManager: AccessTokenManager { get }
    func requestRepositories() async throws -> [GithubRepository]
    func requestLabels(of repository: GithubRepository) async throws -> [Label]
    func createLabel(to repository: GithubRepository, label: Label) async throws
    func deleteLabel(of repository: GithubRepository, label: Label) async throws
}

extension GithubService {
    var token: String? {
        get async throws {
            try await accessTokenManager.requestAccessToken()
        }
    }
}

final class RealGithubService {
    static let shared: GithubService = RealGithubService()
    let session: URLSessionProtocol
    let accessTokenManager: AccessTokenManager

    init(session: URLSessionProtocol = URLSession.shared, accessTokenManager: AccessTokenManager = RealAccessTokenManager()) {
        self.session = session
        self.accessTokenManager = accessTokenManager
    }
}

// MARK: - Protocol 구현부
extension RealGithubService: GithubService {

    func requestLabels(of repository: GithubRepository) async throws -> [Label] {
        guard let token = try await token else {
            throw OAuthError.tokenNotExist
        }
        let (data, _) = try await GithubRepAPI.labels(token: token, of: repository).request(with: session)
        return try JSONDecoder().decode([LabelDAO].self, from: data).map { $0.toLabel() }
    }

    func createLabel(to repository: GithubRepository, label: Label) async throws {
        struct LabelUpload: Encodable {
            let name: String
            let description: String
            let color: String

            init(from label: Label) {
                self.name = label.name
                self.description = label.labelDescription
                self.color = label.hex
            }
        }

        guard let token = try await token else {
            throw OAuthError.tokenNotExist
        }
        let labelData = try JSONEncoder().encode(LabelUpload(from: label))
        let (_, response) = try await GithubRepAPI.createLabel(token: token, of: repository, label: label).post(with: session, data: labelData, delegate: nil)
        guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
    }

    func deleteLabel(of repository: GithubRepository, label: Label) async throws {
        guard let token = try await token else {
            throw OAuthError.tokenNotExist
        }
        let (_, response) = try await GithubRepAPI.deleteLabel(token: token, of: repository, label: label).request(with: session)
        guard let response = response as? HTTPURLResponse, response.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
    }

    func requestRepositories() async throws -> [GithubRepository] {
        guard let token = try await token else {
            throw OAuthError.tokenNotExist
        }
        let (data, _) = try await GithubRepAPI.repositories(token: token).request(with: session)
        let repositories: [GithubRepository] = try JSONDecoder().decode([GithubRepository].self, from: data)

        return repositories
    }
}
