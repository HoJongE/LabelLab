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
    func requestLabels(with token: String, of repository: GithubRepository) async throws -> [Label]
    func createLabel(with token: String, to repository: GithubRepository, label: Label) async throws
    func deleteLabel(with token: String, of repository: GithubRepository, label: Label) async throws
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

    func requestLabels(with token: String, of repository: GithubRepository) async throws -> [Label] {
        let (data, _) = try await GithubRepAPI.labels(token: token, of: repository).request(with: session)
        return try JSONDecoder().decode([LabelDAO].self, from: data).map { $0.toLabel() }
    }

    func createLabel(with token: String, to repository: GithubRepository, label: Label) async throws {
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
        let labelData = try JSONEncoder().encode(LabelUpload(from: label))
        let (_, response) = try await GithubRepAPI.createLabel(token: token, of: repository, label: label).post(with: session, data: labelData, delegate: nil)
        guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
    }

    func deleteLabel(with token: String, of repository: GithubRepository, label: Label) async throws {
        let (_, response) = try await GithubRepAPI.deleteLabel(token: token, of: repository, label: label).request(with: session)
        guard let response = response as? HTTPURLResponse, response.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
    }

    func requestRepositories(with token: String) async throws -> [GithubRepository] {
        let (data, _) = try await GithubRepAPI.repositories(token: token).request(with: session)
        let repositories: [GithubRepository] = try JSONDecoder().decode([GithubRepository].self, from: data)

        return repositories
    }
}
