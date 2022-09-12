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
    func tabButton(of tab: Tab) -> some View {
        Button {
            appState.routing.sidebarRouting.currentTab = tab
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
                Text(userInfo?.nickname ?? "로그인 해주세요")
                    .font(.system(size: 14))
                    .bold()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    func accountProfile(userInfo: UserInfo?) -> some View {
        CircleWebImage(urlString: userInfo?.profileImage, width: 30) {
            Circle()
                .fill(Color.gray)
                .overlay {
                    Image(systemName: "person.fill")
                        .imageScale(.large)
                }
        }
    }
}

// MARK: - Routing
extension Sidebar {
    struct Routing: Equatable {
        var currentTab: Tab = .myTemplate
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
