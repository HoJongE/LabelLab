//
//  MockDIContainer.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/01.
//

@testable import LabelLab

enum MockDIContainerProvider {
    static func mockDIContainer(appState: AppState) -> DIContainer {
        let interactors = DIContainer.Interactors(oAuthInteractor: MockOAuthInteractor(appState: appState))
        return DIContainer(interactors: interactors)
    }
}
