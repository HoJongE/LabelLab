//
//  GithubServiceTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/03.
//

@testable import LabelLab
import KeyChainWrapper
import XCTest

final class GithubServiceTests: XCTestCase {

    private var githubService: GithubService!
    private let testRepository: GithubRepository = .testRepository

    override func setUp() async throws {
        try await super.setUp()
        let mockURLSession: URLSessionProtocol = MockURLSession(data: GithubRepAPI.repositoriesData, response: .init())
        githubService = RealGithubService(session: mockURLSession, accessTokenManager: MockAccessTokenManager())
    }

    override func tearDown() async throws {
        githubService = nil
        try await super.tearDown()
    }

    func testRequestRepositories() async {
        do {
            let repositories = try await githubService.requestRepositories()
            let fromData = try JSONDecoder().decode([GithubRepository].self, from: GithubRepAPI.repositoriesData)

            print(repositories)
            XCTAssertEqual(repositories, fromData)
        } catch {
            XCTFail("Request repositories failed with \(error)")
        }
    }

//    func testCreateAndRequestAndDeleteLabel() async {
//        do {
//            githubService = RealGithubService()
//            let labelToCreate: Label = .mockedData.first!
//            try await githubService.createLabel(with: accessToken, to: testRepository, label: labelToCreate)
//            try await Task.sleep(nanoseconds: 5_000_000_000)
//            var labels: [Label] = try await githubService.requestLabels(with: accessToken, of: testRepository)
//            XCTAssertEqual([labelToCreate].description, labels.description)
//            try await githubService.deleteLabel(with: accessToken, of: testRepository, label: labelToCreate)
//            try await Task.sleep(nanoseconds: 5_000_000_000)
//            labels = try await githubService.requestLabels(with: accessToken, of: testRepository)
//            XCTAssert(labels.isEmpty)
//        } catch {
//            XCTFail("Create label failed with \(error)")
//        }
//    }
}
