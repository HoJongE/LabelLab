//
//  LabelLabApp.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/07/18.
//

import FirebaseCore
import SwiftUI

@main
struct LabelLabApp: App {

    @StateObject private var appState: AppState
    private let diContainer: DIContainer
    private let deepLinkHandler: DeepLinkHandler

    init() {
        let appState = AppState()
        self.diContainer = DIContainer(interactors: .init())
        self.deepLinkHandler = RealDeepLinkHandler(diContainer, appState)
        self._appState = StateObject(wrappedValue: appState)
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .inject(diContainer)
                .inject(appState)
                .handleDeepLink(with: deepLinkHandler)
        }
    }
}

// MARK: - Deep Link View Extension
private extension View {

    func handleDeepLink(with deepLinkHandler: DeepLinkHandler) -> some View {
        self.onOpenURL { url in
            let deepLink: DeepLink? = DeepLink(url)
            guard let deepLink = deepLink else { return }
            deepLinkHandler.open(deepLink)
        }
    }

}
