//
//  FAQ.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/22.
//

import SwiftUI

struct FAQ: View {
    var body: some View {
        ScrollView {
            VStack {
                FAQItem(icon: Image(systemName: "icloud.and.arrow.up.fill"), itemName: "Upload labels to github repository", content: uploadLabels)
                FAQItem(icon: Image(systemName: "lock.fill"), itemName: "Open template to the public", content: templateVisibility)
                FAQItem(icon: Image(systemName: "doc.on.doc.fill"), itemName: "Copy template", content: copyTemplate)
                FAQItem(icon: Image(systemName: "questionmark.folder.fill"), itemName: "Can`t find repository you want", content: cantFindRepository)
            }
            .maxSize(.topLeading)
            .padding()
        }
    }
}

private extension FAQ {
    func uploadLabels() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Please read! If you want to put labels on the repository, you must first login in the lower left area.")
                .bold()
            Text("1. Find the template you want in the Inspiration list left that uploaded by other people, or make your own template")
                .bold()
            Image("templateDetail")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("2. You can find upload button on the top trailing section. If you are login state successfully, the github repositories you have will be appear. You can choose repository and then you are good to go")
                .bold()
            Image("repositoryList")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .font(.title3)
        .padding()
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    func templateVisibility() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("You can find lock icon beside the template name. It means that your template is not open to public. If you want to share your template, click the lock button on the right top. Then your template can requested by other people, but they can`t modify yours")
                .bold()
            Image("templateVisibility")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .font(.title3)
        .padding()
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    func copyTemplate() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("In the inspiration list, you can copy the template other people made, but be sure that you must login first before copying")
                .bold()
            Image("templateCopy")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .font(.title3)
        .padding()
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    func cantFindRepository() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("If you can`t find repository you want, check if that repository is in organization and you don`t give permission to organization")
                .bold()
            Text("You must request organization to grant access this 'Label Lab' application like below image")
                .bold()
            Text("First go to Setting in the github profile, and then find Applications tab and click, Authorized OAuth Apps.\nFind Label Lab and then click it")
                .bold()
            Image("githubApplication")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text("You can find Organization access list. If organization have x mark beside the name, then their repositories don`t come up in upload popup")
                .bold()
            Image("grantAccess")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .font(.title3)
        .padding()
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}
#if DEBUG
struct FAQ_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Sidebar()
            FAQ()
        }
        .injectPreview()
    }
}
#endif
