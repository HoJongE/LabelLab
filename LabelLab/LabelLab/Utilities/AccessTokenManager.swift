//
//  AccessTokenGetter.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/10.
//

import Foundation
import KeyChainWrapper

protocol AccessTokenManager {
    func saveAccessToken(_ token: String) async throws
    func requestAccessToken() async throws -> String?
    func removeAccessToken() async throws
}

struct RealAccessTokenManager {
    private let keychainManager: PasswordKeychainManager

    init() {
        self.keychainManager = PasswordKeychainManager(service: Bundle.main.bundleIdentifier!)
    }
}

extension RealAccessTokenManager: AccessTokenManager {

    func saveAccessToken(_ token: String) async throws {
        try await keychainManager.savePassword(token, for: KeychainConst.accessToken)
    }

    func requestAccessToken() async throws -> String? {
        try await keychainManager.getPassword(for: KeychainConst.accessToken)
    }

    func removeAccessToken() async throws {
        try await keychainManager.removePassword(for: KeychainConst.accessToken)
    }
}
