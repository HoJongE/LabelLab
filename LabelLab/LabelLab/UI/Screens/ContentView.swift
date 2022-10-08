//
//  ContentView.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/07/18.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.injected) private var injected: DIContainer
    @EnvironmentObject private var appState: AppState

    private let isRunningTests: Bool

    init(isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
        self.isRunningTests = isRunningTests
    }

    var body: some View {
        if isRunningTests {
            Text("Running unit tests")
        } else {
            content()
        }
    }
}

// MARK: - Content
private extension ContentView {

    func content() -> some View {
        NavigationView {
            Sidebar()
            appState.routing.sidebarRouting.currentTab.correspondedView
        }
        .sheet(isPresented: $appState.routing.rootRouting.isShowingLoginPopup) {
            AuthorizePopup()
        }
        .sheet(isPresented: $appState.routing.rootRouting.isShowingLogoutPopup, content: {
            LogoutPopup()
        })
        .frame(minWidth: 900, minHeight: 550)
        .preferredColorScheme(.dark)
    }
}

// MARK: - Routing
extension ContentView {

    struct Routing: Equatable {
        var isShowingLoginPopup: Bool = false
        var isShowingLogoutPopup: Bool = false
    }

}

// MARK: - Preview
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .injectPreview()
    }
}
#endif
