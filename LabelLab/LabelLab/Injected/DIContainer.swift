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

    private static let `default` = Self(interactors: Interactors())
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
    func injectPreview() -> some View {
        self.environmentObject(AppState.preview)
            .environment(\.injected, DIContainer.preview)
    }

}
#endif
