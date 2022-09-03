//
//  GithubServiceTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/03.
//

@testable import LabelLab
import XCTest

final class GithubServiceTests: XCTestCase {

    private var githubService: GithubService!

    override func setUp() async throws {
        try await super.setUp()
        let mockURLSession: URLSessionProtocol = MockURLSession(data: GithubRepAPI.repositoriesData, response: .init())
        githubService = RealGithubService(session: mockURLSession)
    }

    override func tearDown() async throws {
        githubService = nil
        try await super.tearDown()
    }

    func testRequestRepositories() async throws {
        let repositories = try await githubService.requestRepositories(with: "")
        let fromData = try JSONDecoder().decode([GithubRepository].self, from: GithubRepAPI.repositoriesData)

        print(repositories)
        XCTAssertEqual(repositories, fromData)
    }
}
