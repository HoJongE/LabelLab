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
                yourLabels()
                community()
                support()
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
    func sideBarButton(title: String, to tab: Tab) -> some View {
        Button {
            appState.routing.sidebarRouting.currentTab = tab
        } label: {
            Text(title)
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
// MARK: - Your Labels section
private extension Sidebar {
    func yourLabels() -> some View {
        Section("Your Labels") {
            sideBarButton(title: "🎨️ Issue Label Maker", to: .myTemplate)
        }
    }
}

// MARK: - Community secion
private extension Sidebar {
    func community() -> some View {
        Section("Community") {
            sideBarButton(title: "💡 Inspirations", to: .inspiration)
        }
    }
}

// MARK: - Support section
private extension Sidebar {
    func support() -> some View {
        Section("Support") {
            sideBarButton(title: "❓ FAQ", to: .faq)
            sideBarButton(title: "📨 Feedback", to: .feedback)
            sideBarButton(title: "⭐ Review", to: .review)
            sideBarButton(title: "☕ Buy me a coffee", to: .buyCoffee)
        }
    }
}

// MARK: - Routing
extension Sidebar {

    enum Tab {
        case myTemplate
        case inspiration
        case faq
        case feedback
        case review
        case buyCoffee
    }

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
