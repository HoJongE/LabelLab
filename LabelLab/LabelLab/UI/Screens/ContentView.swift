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
    @State private var isShowingRepositories: Bool = false

    private let isRunningTests: Bool

    init(isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
        self.isRunningTests = isRunningTests
    }

    var body: some View {
        if isRunningTests {
            Text("Running unit tests")
        }
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button {
                appState.routing.rootRouting.isShowingLoginPopup = true
            } label: {
                Text("팝업 띄우기")
            }
            Button {
                isShowingRepositories = true
            } label: {
                Text("저장소 목록")
            }
        }
        .sheet(isPresented: $appState.routing.rootRouting.isShowingLoginPopup) {
            AuthorizePopup()
        }
        .sheet(isPresented: $isShowingRepositories) {
            RepositoryList(labels: Label.mockedData)
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

// MARK: - Routing
extension ContentView {

    struct Routing: Equatable {
        var isShowingLoginPopup: Bool = false
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
