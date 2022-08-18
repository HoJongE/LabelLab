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

    @StateObject private var appState: AppState = AppState()
    private let diContainer: DIContainer

    init() {
        self.diContainer = DIContainer(interactors: .init())
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .inject(diContainer)
                .inject(appState)
        }
    }
}
