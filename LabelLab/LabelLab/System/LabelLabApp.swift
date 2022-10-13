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
        FirebaseApp.configure()
        var diGenerator: DIGenerator = .init()
        diContainer = diGenerator.diContainer
        deepLinkHandler = diGenerator.deepLinkHandler
        self._appState = StateObject(wrappedValue: diGenerator.appState)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .handleAuthEvent()
                .handleDeepLink(with: deepLinkHandler)
                .inject(diContainer)
                .inject(appState)
                .task {
                    await autoLogin()
                }
        }
        .disableNewWindow()
    }
}

// MARK: - Side Effects
private extension LabelLabApp {
    func autoLogin() async {
        await diContainer.interactors.oAuthInteractor.requestUserInfo()
        if case Loadable.failed = appState.userData.userInfo {
            appState.userData.userInfo = .notRequested
        }
    }
}

// MARK: - Deep Link View Extension
private extension View {

    func handleDeepLink(with deepLinkHandler: DeepLinkHandler) -> some View {
        self.onOpenURL { url in
            let deepLink: DeepLink? = DeepLink(url)
            guard let deepLink = deepLink else { return }
            Task(priority: .userInitiated) {
                await deepLinkHandler.open(deepLink)
            }
        }
    }

    func handleAuthEvent() -> some View {
        handlesExternalEvents(preferring: ["*"], allowing: ["*"])
    }
}

// MARK: - WindowGroup Extension
private extension WindowGroup {
    func disableNewWindow() -> some Scene {
        commands {
            CommandGroup(replacing: .newItem, addition: { })
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
