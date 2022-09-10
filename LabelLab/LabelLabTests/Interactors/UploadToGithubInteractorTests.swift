//
//  UploadToGithubInteractorTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/09.
//

import SwiftUI
@testable import LabelLab
import XCTest

final class UploadToGithubInteractorTests: XCTestCase {

    private var interactor: UploadToGithubInteractor!
    private var appState: AppState!
    private let testRepository: GithubRepository = .testRepository

    override func setUp() async throws {
        try await super.setUp()
        appState = AppState()
        let githubService: GithubService = MockGithubService(session: URLSession.shared)
        interactor = RealUploadToGithubInteractor(githubService: githubService, appState: appState)
    }

    override func tearDown() async throws {
        appState = nil
        interactor = nil
        try await super.tearDown()
    }

    func testRequestRepositories() async {
        let repositories: BindingWrapper<AuthenticationRequiredLoadable<[GithubRepository]>> = .init(value: .notRequested)
        await interactor.requestRepositories(repositories: repositories.binding)
        XCTAssertEqual(repositories.binding.wrappedValue, .loaded(GithubRepository.mockData))
    }

    func testUploadLabels() async {
        // given

        let labels: [LabelLab.Label] = LabelLab.Label.mockedData
        let isUploading: BindingWrapper<Loadable<Void>> = .init(value: .notRequested)
        var result: Bool = false
        await interactor.uploadLabels(to: testRepository, labels: labels, isUploading: isUploading.binding)
        if case .loaded = isUploading.binding.wrappedValue {
            result = true
        }

        XCTAssert(result)
    }
}
