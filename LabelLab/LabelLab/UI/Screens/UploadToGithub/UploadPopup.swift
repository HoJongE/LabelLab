//
//  UploadPopup.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/08.
//

import SwiftUI

struct UploadPopup: View {
    @Environment(\.dismiss) private var dismiss
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
        .background(Color("282828"))
        .frame(width: 440, height: 185)
        .onAppear(perform: uploadLabels)
    }
}

// MARK: - Side Effects
private extension UploadPopup {

    func uploadLabels() {

    }

    func openGithubRepository() {
        guard let url = URL(string: repository.labelsURL) else { return }
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
        // TODO: 공통 button 으로 변경해야함!
        Button {
            dismiss()
        } label: {
            Text("Cancel")
        }
    }
}

// MARK: - Content
private extension UploadPopup {
    @ViewBuilder
    func content() -> some View {
        switch isUploading {
        case .isLoading, .notRequested:
            isLoading()
        case .loaded:
            completed()
        case .failed(let error):
            errorIndicator(error)
        }
    }
}

// MARK: - Loading UI
private extension UploadPopup {
    func isLoading() -> some View {
        VStack {
            Text("Uploading labels to \(repository.name)...")
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    func checkRepositoryButton() -> some View {
        // TODO: 공통 BUtton 으로 변경해야 함!
        Button {
            openGithubRepository()
        } label: {
            Text("Check Remote Repository")
        }
    }
}

// MARK: - Error UI
private extension UploadPopup {
    func errorIndicator(_ error: Error) -> some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("❌ Failed to upload labels")
                .padding(.leading, 48)
            Spacer()
            HStack {
                Spacer()
                cancelButton()
                uploadLabelsButton()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 29, trailing: 18))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    func uploadLabelsButton() -> some View {
        Button {
            uploadLabels()
        } label: {
            Text("Upload labels again")
        }
    }
}

struct UploadPopup_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UploadPopup(to: .mockData.first!, labels: Label.mockedData)
                .previewDisplayName("Not reuqested")
            UploadPopup(isUploading: .isLoading(last: nil), to: .mockData.first!, labels: Label.mockedData)
                .previewDisplayName("is Loading")
            UploadPopup(isUploading: .failed(NSError()), to: .mockData.first!, labels: Label.mockedData)
                .previewDisplayName("Error")
            UploadPopup(isUploading: .loaded(()), to: .mockData.first!, labels: Label.mockedData)
                .previewDisplayName("Loaded")
        }
    }
}
