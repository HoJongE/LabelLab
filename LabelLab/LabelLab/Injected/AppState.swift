//
//  AppState.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

import Foundation

final class AppState: ObservableObject {
    @Published var userData: UserData
    @Published var routing: ViewRouting

    init(_ userData: UserData = UserData(), _ routing: ViewRouting = ViewRouting()) {
        self.userData = userData
        self.routing = routing
    }
}

// MARK: - User data
extension AppState {

    struct UserData {
        var userInfo: Loadable<UserInfo>
        // for Template List

        init(userInfo: Loadable<UserInfo> = .notRequested) {
            self.userInfo = userInfo
        }
    }

}

// MARK: - Routing
extension AppState {

    struct ViewRouting: Equatable {
        var rootRouting = ContentView.Routing()
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
