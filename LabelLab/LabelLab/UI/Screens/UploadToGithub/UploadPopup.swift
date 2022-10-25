//
//  UploadPopup.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/08.
//

import SwiftUI

struct UploadPopup: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.injected) private var diContainer: DIContainer
    @State private var isUploading: Loadable<Void> = .notRequested

    private let repository: GithubRepository
    private let labels: [Label]

    init(isUploading: Loadable<Void> = .notRequested, to repository: GithubRepository, labels: [Label]) {
        self._isUploading = State(initialValue: isUploading)
        self.repository = repository
        self.labels = labels
    }

    var body: some View {
        VStack(spacing: 0) {
            statusBar()
            content()
        }
        // MARK: - replace to Color assests
        .background(Color.detailBackground)
        .frame(width: 440, height: 185)
    }
}

// MARK: - Side Effects
private extension UploadPopup {

    func uploadLabels() {
        Task(priority: .userInitiated) {
            await diContainer.interactors.uploadToGithubInteractor.uploadLabels(to: repository, labels: labels, isUploading: $isUploading)
        }
    }

    func openGithubRepository() {
        guard let url = repository.labelPageURL else { return }
        NSWorkspace.shared.open(url)
    }
}
// MARK: - UI Components
private extension UploadPopup {
    func statusBar() -> some View {
        Text("Upload to \(repository.name)")
            .bold()
            .padding(.vertical, 6)
            .foregroundColor(.statusTitle)
            .frame(maxWidth: .infinity)
            .background(Color.statusBackground)
    }

    func cancelButton() -> some View {
        DefaultButton(text: "Cancel") {
            dismiss()
        }
    }
}

// MARK: - Content
private extension UploadPopup {
    @ViewBuilder
    func content() -> some View {
        switch isUploading {
        case .notRequested:
            empty()
        case .isLoading:
            isLoading()
        case .loaded:
            completed()
        case .failed(let error):
            errorIndicator(error)
        }
    }
}

// MARK: - Empty UI
private extension UploadPopup {
    func empty() -> some View {
        VStack {
        }
        .onAppear(perform: uploadLabels)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
// MARK: - Loading UI
private extension UploadPopup {
    func isLoading() -> some View {
        VStack {
            Text("Uploading labels to \(repository.name)...")
            ProgressView()
        }
        .maxSize(.center)
    }
}

// MARK: - Complete Upload
private extension UploadPopup {
    func completed() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("🎉 Labels uploaded successfully")
                .padding(.leading, 48)
            Spacer()
            HStack {
                Spacer()
                cancelButton()
                checkRepositoryButton()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 29, trailing: 18))
        }
        .maxSize(.topLeading)
    }

    func checkRepositoryButton() -> some View {
        DefaultButton(text: "Check Remote Repository", style: .primary) {
            openGithubRepository()
        }
    }
}

// MARK: - Error UI
private extension UploadPopup {
    func errorIndicator(_ error: Error) -> some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("❌ Failed to upload labels\n\(error.localizedDescription)")
                .multilineTextAlignment(.center)
                .padding(.leading, 48)
            Spacer()
            HStack {
                Spacer()
                cancelButton()
                uploadLabelsButton()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 29, trailing: 18))
        }
        .maxSize(.topLeading)
    }

    func uploadLabelsButton() -> some View {
        DefaultButton(text: "Uplpoad labels again") {
            uploadLabels()
        }
    }
}
#if DEBUG
struct UploadPopup_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UploadPopup(to: .mockData.first!, labels: Label.mockedData)
                .previewDisplayName("Not reuqested")
                .injectPreview()

            UploadPopup(isUploading: .isLoading(last: nil), to: .mockData.first!, labels: Label.mockedData)
                .previewDisplayName("is Loading")
                .injectPreview()

            UploadPopup(isUploading: .failed(NSError()), to: .mockData.first!, labels: Label.mockedData)
                .previewDisplayName("Error")
                .injectPreview()

            UploadPopup(isUploading: .loaded(()), to: .mockData.first!, labels: Label.mockedData)
                .previewDisplayName("Loaded")
                .injectPreview()

        }
    }
}
#endif
