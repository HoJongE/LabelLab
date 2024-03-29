//
//  AuthorizePopup.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

import SwiftUI

struct AuthorizePopup: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.injected) private var diContainer: DIContainer
    @EnvironmentObject private var appState: AppState

    var body: some View {
        content()
            .frame(width: 439, height: 186, alignment: .topLeading)
    }
}

// MARK: - UI Componenets
private extension AuthorizePopup {

    var statusTitle: some View {
        Text("Github Accounts")
            .fontWeight(.bold)
            .foregroundColor(.statusTitle)
            .frame(maxWidth: .infinity)
    }

    var dismissButton: some View {
        DismissButton {
            dismiss()
        }
    }

    var finishButton: some View {
        DefaultButton(text: "Finish", style: .primary) {
            dismiss()
        }
    }

    var authorizeButton: some View {
        HStack {
            Spacer()
            DefaultButton(text: "Authorize Github", onClick: authorizeGithub)
        }
    }
}

// MARK: - Side Effects
private extension AuthorizePopup {
    func authorizeGithub() {
        diContainer.interactors.oAuthInteractor.openOAuthSite()
    }
}

// MARK: - Content
private extension AuthorizePopup {
    @ViewBuilder
    func content() -> some View {
        switch appState.userData.userInfo {
        case .notRequested:
            notRequested()
        case .isLoading:
            loading()
        case .loaded(let userInfo):
            loaded(userInfo)
        case .failed(let error):
            errorIndicator(error)
        }
    }
}

// MARK: - not requested view
private extension AuthorizePopup {
    func notRequested() -> some View {
        VStack {
            HStack {
                dismissButton.frame(maxWidth: .infinity, alignment: .leading)
                statusTitle.frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(maxWidth: .infinity)
            }
            .background(Color.statusBackground)
            Spacer()
            Text("Sign in here to make and upload your own labels")
            Spacer()
            authorizeButton.padding()
        }
    }

}

// MARK: - loading view
private extension AuthorizePopup {

    func loading() -> some View {
        VStack {
            HStack {
                statusTitle
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
            }
            .background(Color.statusBackground)

            Spacer()
            Text("Requesting Github Access token")
                .fontWeight(.semibold)
            ProgressView()
                .progressViewStyle(.circular)

            Spacer()

        }
    }
}

// MARK: - loaded View
private extension AuthorizePopup {
    func loaded(_ userInfo: UserInfo) -> some View {
        VStack {
            HStack {
                statusTitle
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(EdgeInsets(top: 6, leading: 0, bottom: 6, trailing: 0))
            }
            .background(Color.statusBackground)
            Spacer()
            HStack(spacing: 0) {
                successIcon.padding(.trailing, 22)
                Text("Congratulations, you`re all set!").fontWeight(.bold)
                Spacer()
            }
            .padding(.leading, 39)
            HStack {
                Spacer()
                finishButton.padding(.trailing, 33)
            }
            Spacer()
        }
    }

    var successIcon: some View {
        Text(Image(systemName: "checkmark.circle.fill"))
            .fontWeight(.bold)
            .foregroundColor(.green)
            .font(.system(size: 42))
    }

}

// MARK: - error view
private extension AuthorizePopup {
    func errorIndicator(_ error: Error) -> some View {
        VStack {
            HStack {
                dismissButton.frame(maxWidth: .infinity, alignment: .leading)
                statusTitle.frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(maxWidth: .infinity)
            }
            .background(Color.statusBackground)
            Spacer()
            HStack(spacing: 0) {
                failIcon.padding(.trailing, 22)
                Text("An Error occur when signing in, Please try again").fontWeight(.bold)
                Spacer()
            }
            .padding(.leading, 22)
            HStack {
                Spacer()
                authorizeButton.padding(.trailing, 33)
            }
            Spacer()
        }
    }

    var failIcon: some View {
        Text(Image(systemName: "xmark.circle.fill"))
            .fontWeight(.bold)
            .foregroundColor(.red)
            .font(.system(size: 42))
    }
}

// MARK: - Preview
#if DEBUG
struct AuthorizePopup_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AuthorizePopup()
                .injectPreview(AppState(AppState.UserData(userInfo: .notRequested)))
                .previewDisplayName("Empty User")
            AuthorizePopup()
                .injectPreview(AppState(AppState.UserData(userInfo: .isLoading(last: nil))))
                .previewDisplayName("Loading")
            AuthorizePopup()
                .injectPreview(AppState(AppState.UserData(userInfo: .loaded(UserInfo.hojonge))))
                .previewDisplayName("Loaded")
            AuthorizePopup()
                .injectPreview(AppState(AppState.UserData(userInfo: .failed(NSError()))))
                .previewDisplayName("Fail")
        }
    }
}
#endif
