//
//  AppState.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

import Foundation

final class AppState: ObservableObject {
    @Published var userData: UserData = UserData()
    @Published var routing: ViewRouting = ViewRouting()
}

// MARK: - User data
extension AppState {

    struct UserData {
        // for Template List
    }

}

// MARK: - Routing
extension AppState {

    struct ViewRouting: Equatable {
    }

}

// MARK: - For Preview
#if DEBUG
extension AppState {
    static var preview: AppState {
        AppState()
    }
}
#endif