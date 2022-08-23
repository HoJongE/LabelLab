//
//  DeepLinkHandler.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

import Foundation

enum DeepLink {
    case authorize(authorizeCode: String)

    init?(_ url: URL) {
        let urlString: String = url.absoluteString
        if urlString.contains("login") {
            let code = urlString.split(separator: "=").last.map { String($0) }
            guard let code = code else { return nil }
            self = .authorize(authorizeCode: code)
            return
        }

        return nil
    }
}

extension DeepLink: Equatable {
    static func == (lhs: DeepLink, rhs: DeepLink) -> Bool {
        switch (lhs, rhs) {
        case (.authorize(let first), .authorize(let second)) where first == second: return true
        default: return false
        }
    }
}

protocol DeepLinkHandler {
    func open(_ deepLink: DeepLink)
}

final class RealDeepLinkHandler: DeepLinkHandler {

    func open(_ deepLink: DeepLink) {
        switch deepLink {
        case .authorize(let authorizeCode):
            print(authorizeCode)
        }
    }
}
