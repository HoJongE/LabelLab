//
//  OAuthService.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

protocol OAuthService {
    func openOAuthSite()
}

final class GithubOAuthService {
    static let shared: GithubOAuthService = .init()

    private init() {}
}

#if canImport(AppKit)

import AppKit

extension GithubOAuthService: OAuthService {
    func openOAuthSite() {
        guard let url = GithubAPI.authorize.url else { return }
        NSWorkspace.shared.open(url)
    }
}
#endif
