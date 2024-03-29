//
//  DIContainer.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

import SwiftUI

struct DIContainer: EnvironmentKey {

    let interactors: Interactors

    init(interactors: Interactors) {
        self.interactors = interactors
    }

    static var defaultValue: Self { Self.default }

    private static var `default`: Self {
        let appState: AppState = AppState()
        return Self(interactors: Interactors(
            oAuthInteractor: RealOAuthInteractor(appState: appState),
            uploadToGithubInteractor: RealUploadToGithubInteractor(appState: appState),
            myTemplateListInteractor: RealMyTemplateListInteractor(appState: appState),
            templateDetailInteractor: RealTemplateDetailInteractor(appState: appState),
            labelListInteractor: RealLabelListInteractor(appState: appState),
            inspirationInteractor: RealInspirationInteractor(appState: appState)
        ))
    }
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

// MARK: - View Extension to inject DIContainer
extension View {

    @ViewBuilder
    func inject(_ container: DIContainer) -> some View {
        environment(\.injected, container)
    }

    @ViewBuilder
    func inject(_ appState: AppState) -> some View {
        environmentObject(appState)
    }

}

#if DEBUG
// MARK: - For preview
extension DIContainer {
    static var preview: DIContainer {
        DIContainer(interactors: Interactors.preview)
    }
}

extension View {

    @ViewBuilder
    func injectPreview(_ appState: AppState? = nil, _ diConainter: DIContainer? = nil) -> some View {
        self.environmentObject(appState ?? AppState.preview)
            .environment(\.injected, diConainter ?? DIContainer.preview)
    }

}
#endif
