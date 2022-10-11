//
//  MockAccessTokenManager.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/10.
//

@testable import LabelLab

struct MockAccessTokenManager: AccessTokenManager {

    func saveAccessToken(_ token: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_00)
    }

    func requestAccessToken() async throws -> String? {
        return "123"
    }

    func removeAccessToken() async throws {
        try await Task.sleep(nanoseconds: 1_000_000_00)
    }
}
