//
//  RepositoryList.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/03.
//

import SwiftUI

struct RepositoryList: View {
    @State private var repositories: AuthenticationRequiredLoadable<[GithubRepository]>
    @EnvironmentObject private var appState: AppState
    @Environment(\.injected) private var diContainer: DIContainer
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRepository: GithubRepository?
    private let labels: [Label]
    private let templateName: String

    init(repositories: AuthenticationRequiredLoadable<[GithubRepository]> = .notRequested, labels: [Label], templateName: String) {
        self._repositories = State(initialValue: repositories)
        self.labels = labels
        self.templateName = templateName
    }

    var body: some View {
        VStack(spacing: 0) {
            statusTitle
            content(repositories)
        }
        .frame(width: 454, height: 580)
        .background(Color.detailBackground)
        .sheet(isPresented: $appState.routing.repositoryListRouting.isShowingUploadPopup) {
            if let selectedRepository = selectedRepository {
                UploadPopup(to: selectedRepository, labels: labels)
            }
        }
    }
}

// MARK: - Side Effects
private extension RepositoryList {

    func requestRepositories() {
        Task(priority: .userInitiated) {
            await diContainer.interactors.uploadToGithubInteractor.requestRepositories(repositories: $repositories)
        }
    }

    func uploadLabels() {
        appState.routing.repositoryListRouting.isShowingUploadPopup = true
    }
}

// MARK: - UI Components
private extension RepositoryList {
    var statusTitle: some View {
        Text("Upload to Github")
            .bold()
            .foregroundColor(.statusTitle)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.statusBackground)
    }
}

// MARK: - content
private extension RepositoryList {
    @ViewBuilder
    func content(_ repositories: AuthenticationRequiredLoadable<[GithubRepository]>) -> some View {
        switch repositories {
        case .notRequested:
            empty()
        case .isLoading:
            loading()
        case .loaded(let repositories):
            loaded(repositories)
        case .failed(let error):
            errorIndicator(error)
        case .needAuthentication:
            EmptyView()
        }
    }
}

// MARK: - Routing
extension RepositoryList {
    struct Routing: Equatable {
        var isShowingUploadPopup: Bool = false
    }
}

// MARK: - Empty UI
private extension RepositoryList {
    func empty() -> some View {
        VStack {
        }
        .onAppear(perform: requestRepositories)
        .maxSize(.topLeading)
    }
}

// MARK: - Loading UI
private extension RepositoryList {
    func loading() -> some View {
        VStack {
            Spacer()
            ProgressView()
            Text("Loading repositories...")
                .bold()
                .padding()
            Spacer()
        }
        .maxSize(.center)
    }
}

// MARK: - Loaded UI
private extension RepositoryList {
    func loaded(_ repositories: [GithubRepository]) -> some View {

        VStack {
            Text("Please select a repository to upload\n\(labels.count) labels from \"\(templateName)\"")
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 35)
            list(repositories)
            buttons()
        }
        .maxSize(.center)
    }

    func list(_ repositories: [GithubRepository]) -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            ForEach(repositories) { repository in
                Cell(repository: repository, isSelected: selectedRepository == repository) {
                    selectedRepository = repository
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }

    func buttons() -> some View {
        HStack {
            DefaultButton(text: "Cancel") {
                dismiss()
            }
            Spacer()
            DefaultButton(text: "Upload", style: .primary) {
                uploadLabels()
            }
            .disabled(selectedRepository == nil)
        }
        .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))
    }

    struct Cell: View {
        private let repository: GithubRepository
        private let isSelected: Bool
        private let onClick: () -> Void
        @State private var isHover: Bool = false

        init(repository: GithubRepository, isSelected: Bool = false, onClick: @escaping () -> Void = { }) {
            self.repository = repository
            self.onClick = onClick
            self.isSelected = isSelected
        }

        var body: some View {
            HStack(alignment: .center) {
                CircleWebImage(urlString: repository.owner.profileImage)
                    .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 8))
                Text(repository.fullName)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill((isHover || isSelected) ? .blue: .cellBackground ))
            .onHover(perform: { isHover = $0 })
            .contentShape(Rectangle())
            .onTapGesture(perform: onClick)
        }
    }
}

// MARK: - Error UI
private extension RepositoryList {
    func errorIndicator(_ error: Error) -> some View {
        VStack {
            Text("An error occur when loading github repositories")
                .bold()

            Text(error.localizedDescription)

            Button(action: requestRepositories) {
                Text("Please try again")
            }
            .padding()
            buttons()
        }
        .maxSize(.center)
    }
}

struct RepositoryList_Previews: PreviewProvider {
    static func makePreview(_ repositories: AuthenticationRequiredLoadable<[GithubRepository]> = .notRequested) -> some View {
        RepositoryList(repositories: repositories, labels: Label.mockedData, templateName: "WWDC study")
            .previewDisplayName(repositories.previewDisplayName)
    }
    static var previews: some View {
        Group {
            makePreview()
            makePreview(.isLoading(last: nil))
            makePreview(.loaded(GithubRepository.mockData))
            makePreview(.failed(OAuthError.dataNotExist))
        }
        .injectPreview()
    }
}
