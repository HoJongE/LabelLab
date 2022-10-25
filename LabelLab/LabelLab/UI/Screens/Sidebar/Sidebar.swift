//
//  Sidebar.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/11.
//

import SwiftUI

struct Sidebar: View {

    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(TabSection.allCases, id: \.self) { section in
                    Section(section.rawValue) {
                        ForEach(section.tabs, id: \.self) { tab in
                            tabButton(of: tab)
                        }
                    }
                }
            }
            Spacer()
            accountInfo()
                .padding(.bottom, 24)
                .padding(.leading, 16)
        }
        .toolbar {
            Text("")
        }
        .frame(width: 200)
    }
}

// MARK: - Side effects
private extension Sidebar {
    func openAccountInfo() {
        if appState.userData.userInfo.value == nil {
            appState.routing.rootRouting.isShowingLoginPopup = true
        } else {
            appState.routing.rootRouting.isShowingLogoutPopup = true
        }
    }
}
// MARK: - UI Component
private extension Sidebar {

    func mailto(_ email: String) {
        guard let mailto = "mailto:\(email)?subject=Feedback of LabelLab".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        guard let url = URL(string: mailto) else { return }
        NSWorkspace.shared.open(url)
    }

    func requestReview() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id6443861492?action=write-review")
                else { return }
        NSWorkspace.shared.open(writeReviewURL)
    }

    func onTabClick(_ tab: Tab) {
        switch tab {
        case .myTemplate:
            appState.routing.sidebarRouting.currentTab = tab
        case .inspiration:
            appState.routing.sidebarRouting.currentTab = tab
        case .faq:
            appState.routing.sidebarRouting.currentTab = tab
        case .feedback:
            mailto("pjh00098@gmail.com")
        case .review:
            requestReview()
//        case .buyCoffee:
//            appState.routing.sidebarRouting.currentTab = tab
        }
    }

    func tabButton(of tab: Tab) -> some View {
        Button {
            onTabClick(tab)
        } label: {
            Text(tab.rawValue)
                .fontWeight(.regular)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
        }
        .padding(4)
        .background {
            if appState.routing.sidebarRouting.currentTab == tab {
                RoundedRectangle(cornerRadius: 6).fill(Color.blue)
            }
        }
        .buttonStyle(.plain)
    }

    func accountInfo() -> some View {
        let userInfo: UserInfo? = appState.userData.userInfo.value
        return Button(action: openAccountInfo) {
            HStack(spacing: 8) {
                accountProfile(userInfo: userInfo)
                Text(userInfo?.nickname ?? "Please login to github")
                    .font(.system(size: 14))
                    .bold()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    func accountProfile(userInfo: UserInfo?) -> some View {
        CircleWebImage(urlString: userInfo?.profileImage, width: 30)
    }
}

// MARK: - Routing
extension Sidebar {
    struct Routing: Equatable {
        var currentTab: Tab = .inspiration
    }
}

#if DEBUG
struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Sidebar()
            EmptyView()
        }
        .injectPreview()
    }
}
#endif
