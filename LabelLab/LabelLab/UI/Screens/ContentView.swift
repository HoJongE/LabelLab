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
        }
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .injectPreview()
    }
}
#endif