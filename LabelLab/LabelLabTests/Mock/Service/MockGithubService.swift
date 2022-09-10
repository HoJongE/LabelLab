//
//  MockGithubService.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/09.
//

@testable import LabelLab

final class MockGithubService: GithubService {

    let session: LabelLab.URLSessionProtocol
    let accessTokenManager: AccessTokenManager
    var labels: [Label] = Label.mockedData

    init(session: LabelLab.URLSessionProtocol, accessTokenManager: AccessTokenManager = RealAccessTokenManager()) {
        self.session = session
        self.accessTokenManager = accessTokenManager
    }

    func requestRepositories() async throws -> [LabelLab.GithubRepository] {
        LabelLab.GithubRepository.mockData
    }

    func requestLabels(of repository: LabelLab.GithubRepository) async throws -> [LabelLab.Label] {
        labels
    }

    func createLabel(to repository: LabelLab.GithubRepository, label: LabelLab.Label) async throws {

    }

    func deleteLabel(of repository: LabelLab.GithubRepository, label: LabelLab.Label) async throws {

    }
}
