//
//  InspirationList.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/17.
//

import SwiftUI

struct InspirationList: View {

    @EnvironmentObject private var appState: AppState
    @Environment(\.injected) private var diContainer: DIContainer
    @State private var inspirations: Loadable<[Template]> = .notRequested

    init(inspirations: Loadable<[Template]> = .notRequested) {
        self._inspirations = State(initialValue: inspirations)
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            tabName()
            title()
            divider()
            content()
        }
        .padding()
        .maxSize(.topLeading)
        .overlay {
            if let template = appState.routing.inspirationListRouting.template {
                MyTemplateDetail(template: template)
                    .transition(.opacity)
                    .zIndex(4)
            }
        }
    }
}

// MARK: - Side Effects
private extension InspirationList {
    func requestTemplates() {
    }
}

// MARK: - Content
private extension InspirationList {
    @ViewBuilder
    func content() -> some View {
        switch inspirations {
        case .notRequested:
            Text("")
                .onAppear(perform: requestTemplates)
        case .isLoading(last: let last):
            loading(last)
        case .loaded(let templates):
            loaded(templates)
        case .failed(let error):
            EmptyView()
        }
    }
}

// MARK: - Loading
private extension InspirationList {
    @ViewBuilder
    func loading(_ templates: [Template]?) -> some View {
        VStack {
            if let templates {
                list(templates, isLoading: true)
            } else {
                ProgressView()
            }
        }
        .maxSize(.center)
    }
}
// MARK: - Loaded
private extension InspirationList {
    @ViewBuilder
    func loaded(_ templates: [Template]) -> some View {
        if templates.isEmpty {
            emptyView()
        } else {

        }
    }
}

// MARK: - Failed
private extension InspirationList {
    func failed(error: Error) -> some View {
        VStack {
            Text("An error occur when load templates!\(error.localizedDescription)")
                .bold()
            DefaultButton(text: "try again", style: .primary) {
                requestTemplates()
            }
            .padding()
        }
        .maxSize(.center)
    }
}

// MARK: - emptyView
private extension InspirationList {
    func emptyView() -> some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                VStack {
                    Image("ic_flask")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                    Text("Ouhh.. it’s empty in here")
                        .font(.system(.title3)).bold()
                    Group {
                        Text("How about make your own template and share it!")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(Color.white80)
                }
                Spacer()
            }
            Spacer()
        }
    }
}

// MARK: - UI Components
private extension InspirationList {

    func tabName() -> some View {
        Text("Inspirations")
            .bold()
            .font(.title3)
            .foregroundColor(.white.opacity(0.8))
            .padding(.bottom, 16)
    }
    func title() -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Explore other people`s templates")
                .bold()
                .font(.title)
            Spacer()
        }
    }

    func divider() -> some View {
        Rectangle()
            .fill(Color.white.opacity(0.1))
            .frame(maxWidth: .infinity)
            .frame(height: 1.5)
            .padding(.vertical, 16)
    }

    func list(_ templates: [Template], isLoading: Bool = false) -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 340))]) {
                ForEach(templates) { template in
                    cell(template)
                }
            }
            .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    func cell(_ template: Template) -> some View {
        InspirationTemplateCell(template: template, onClick: onCellClick(_:)) { _ in
            // on Copy
        }
    }

    func onCellClick(_ template: Template) {
        withAnimation(.easeInOut) {
            appState.routing.inspirationListRouting.template = template
        }
    }
}

// MARK: - Routing
extension InspirationList {
    struct Routing: Equatable {
        var template: Template?
    }
}
// MARK: - Preview
struct InspirationList_Previews: PreviewProvider {

    static func makePreview(_ inspirations: Loadable<[Template]> = .notRequested) -> some View {

        return NavigationView {
            Sidebar()
            InspirationList(inspirations: inspirations)
        }
        .previewDisplayName(inspirations.previewDisplayName)
        .injectPreview()
        .frame(width: 930, height: 500)
    }

    static var previews: some View {
        Group {
            makePreview(.notRequested)
            makePreview(.isLoading(last: Template.mockedData))
            makePreview(.failed(OAuthError.dataNotExist))
            makePreview(.loaded([]))
            makePreview(.loaded(Template.mockedData))
        }
    }
}
