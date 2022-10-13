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

    init(_ userData: UserData = UserData(),
         _ routing: ViewRouting = ViewRouting()) {
        self.userData = userData
        self.routing = routing
    }

}

// MARK: - User data
extension AppState {

    struct UserData {
        var userInfo: Loadable<UserInfo>
        var myTemplateList: AuthenticationRequiredLoadable<[Template]>
        // for Template List

        init(userInfo: Loadable<UserInfo> = .notRequested,
             myTemplateList: AuthenticationRequiredLoadable<[Template]> = .notRequested) {
            self.userInfo = userInfo
            self.myTemplateList = myTemplateList
        }
    }
}

// MARK: - Routing
extension AppState {

    struct ViewRouting: Equatable {
        var rootRouting: ContentView.Routing = .init()
        var repositoryListRouting: RepositoryList.Routing = .init()
        var sidebarRouting: Sidebar.Routing = .init()
        var myTemplateListRouting: MyTemplateList.Routing = .init()
        var myTemplateDetailRouting: MyTemplateDetail.Routing = .init()
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
