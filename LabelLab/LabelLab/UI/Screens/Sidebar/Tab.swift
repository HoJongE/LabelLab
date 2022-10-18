//
//  Tab.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/12.
//

import SwiftUI

enum TabSection: String, Equatable, CaseIterable {
    case yourLabels = "Your Labels"
    case community = "Community"
    case support = "Support"
}

extension TabSection {
    var tabs: [Tab] {
        switch self {
        case .yourLabels:
            return [.myTemplate]
        case .community:
            return [.inspiration]
        case .support:
            return [.faq, .feedback, .review, .buyCoffee]
        }
    }
}

enum Tab: String, Equatable {
    case myTemplate = "🎨️ Issue Label Maker"
    case inspiration = "💡 Inspirations"
    case faq = "❓ FAQ"
    case feedback = "📨 Feedback"
    case review = "⭐ Review"
    case buyCoffee = "☕ Buy me a coffee"
}

extension Tab {

    @ViewBuilder
    var correspondedView: some View {
        switch self {
        case .myTemplate:
            MyTemplateList()
        case .inspiration:
            InspirationList(inspirations: .isLoading(last: Template.mockedData))
        case .faq:
            Text("FAQ")
        case .feedback:
            Text("Feedback")
        case .review:
            Text("Review")
        case .buyCoffee:
            Text("Buy me a coffee")
        }
    }
}
