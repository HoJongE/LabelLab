//
//  OAuthService.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

import Foundation
import AppKit

protocol OAuthService {
    func openOAuthSite()
}

final class GithubOAuthService {
    static let shared: GithubOAuthService = .init()

    private var oAuthSiteURL: String {
        "https://github.com/login/oauth/authorize?client_id=\(KeyStorage.GithubClientId)&scope=user,repo"
    }

    private init() {}
}

extension GithubOAuthService: OAuthService {
    func openOAuthSite() {
        guard let url = URL(string: oAuthSiteURL) else { return }
        #if os(macOS)
        NSWorkspace.shared.open(url)
        #endif
    }
}

