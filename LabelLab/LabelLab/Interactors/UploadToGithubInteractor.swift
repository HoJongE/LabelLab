//
//  UploadToGithubInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/09.
//

import Foundation
import KeyChainWrapper

protocol UploadToGithubInteractor {
    func requestRepositories(repositories: AuthLoadableSubject<[GithubRepository]>) async
    func uploadLabels(to repository: GithubRepository, labels: [Label], isUploading: LoadableSubject<Void>) async
}

struct RealUploadToGithubInteractor {
    private let githubService: GithubService
    private let appState: AppState

    init(githubService: GithubService = RealGithubService.shared, appState: AppState) {
        self.githubService = githubService
        self.appState = appState
    }
}

extension RealUploadToGithubInteractor: UploadToGithubInteractor {

    @MainActor func requestRepositories(repositories: AuthLoadableSubject<[GithubRepository]>) async {
        do {
            repositories.wrappedValue = .isLoading(last: nil)
            let loaded: [GithubRepository] = try await githubService.requestRepositories()
            repositories.wrappedValue = .loaded(loaded)
        } catch {
            repositories.wrappedValue = .failed(error)
        }
    }

    @MainActor func uploadLabels(to repository: GithubRepository, labels: [Label], isUploading: LoadableSubject<Void>) async {
        do {
            isUploading.wrappedValue = .isLoading(last: nil)
            try await removeLabels(of: repository)
            try await createLabels(to: repository, labels: labels)
            isUploading.wrappedValue = .loaded(())
        } catch {
            isUploading.wrappedValue = .failed(error)
        }
    }
}

private extension RealUploadToGithubInteractor {

    func removeLabels(of repository: GithubRepository) async throws {
        let labels: [Label] = try await githubService.requestLabels(of: repository)
        try await withThrowingTaskGroup(of: Void.self) { group in
            for label in labels {
                group.addTask {
                    try await githubService.deleteLabel(of: repository, label: label)
                }
            }
            try await group.waitForAll()
        }
    }

    func createLabels(to repository: GithubRepository, labels: [Label]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for label in labels {
                group.addTask {
                    try await githubService.createLabel(to: repository, label: label)
                }
            }
            try await group.waitForAll()
        }
    }
}
