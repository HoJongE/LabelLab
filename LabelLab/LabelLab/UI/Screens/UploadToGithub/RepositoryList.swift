//
//  RepositoryList.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/03.
//

import SwiftUI

struct RepositoryList: View {
    @State private var repositories: AuthenticationRequiredLoadable<[GithubRepository]>
    @Environment(\.injected) private var diContainer: DIContainer
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRepository: GithubRepository?

    init(repositories: AuthenticationRequiredLoadable<[GithubRepository]> = .notRequested) {
        self._repositories = State(initialValue: repositories)
    }

    var body: some View {
        VStack(spacing: 0) {
            statusTitle
            content(repositories)
        }
        .frame(width: 454, height: 580)
        .background(Color("282828"))
        .onAppear(perform: requestRepositories)
    }
}

// MARK: - Side Effects
private extension RepositoryList {
    // TODO: Interactor 와 상호작용
    func requestRepositories() {

    }

    func uploadLabels() {

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

// MARK: - Empty UI
private extension RepositoryList {
    func empty() -> some View {
        VStack {
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

// MARK: - Loaded UI
private extension RepositoryList {
    func loaded(_ repositories: [GithubRepository]) -> some View {

        // TODO: Template 과 labels 받아서 표시해야함
        VStack {
            Text("Please select a repository to upload\nN labels from \"WWDC Study\"")
                .bold()
                .multilineTextAlignment(.center)
                .padding(.top, 35)
            list(repositories)
            buttons()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
        // TODO: Avery 가 만든 버튼으로 교체, Interactor 와 상호작용 해야 함!
        HStack {
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .fontWeight(.medium)
            }
            Spacer()
            Button {

            } label: {
                Text("Upload")
                    .fontWeight(.medium)
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
                CircleWebImage(url: repository.owner.profileImage)
                    .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 8))
                Text(repository.fullName)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            // TODO: Color assest 으로 교체 필요!
            .background(RoundedRectangle(cornerRadius: 10).fill((isHover || isSelected) ? Color.blue: Color("3D3C3D") ))
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

            Button(action: requestRepositories) {
                Text("Please try again")
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct RepositoryList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RepositoryList()
                .previewDisplayName("not Requested")
            RepositoryList(repositories: .isLoading(last: nil))
                .previewDisplayName("loading UI")
            RepositoryList(repositories: .loaded(GithubRepository.mockData))
                .previewDisplayName("loaded UI")
            RepositoryList(repositories: .failed(NSError()))
                .previewDisplayName("error Indicator")
        }
        .inject(DIContainer.preview)
    }
}
