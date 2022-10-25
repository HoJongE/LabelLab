//
//  LogoutPopup.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/11.
//

import SwiftUI

struct LogoutPopup: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.injected) private var diContianer: DIContainer

    var body: some View {
        VStack {
            Text("Do you really want to logout?")
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("cancel")
                }
                .padding()

                Button(action: logout) {
                    Text("logout")
                }
                .padding()
            }
        }
        .padding()
    }
}

// MARK: - Side Effects
private extension LogoutPopup {
    func logout() {
        Task(priority: .userInitiated) {
            await diContianer.interactors.oAuthInteractor.logout()
            await MainActor.run {
                dismiss()
            }
        }
    }
}
#if DEBUG
struct LogoutPopup_Previews: PreviewProvider {
    static var previews: some View {
        LogoutPopup()
            .injectPreview()
    }
}
#endif
