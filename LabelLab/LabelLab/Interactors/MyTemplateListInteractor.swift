//
//  MyTemplateListInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/22.
//

protocol MyTemplateListInteractor {
    func addTemplate(template: Template) async
    func changeTemplateVisibility(of template: Template, isChanging: LoadableSubject<Void>) async
    func deleteTemplate(_ template: Template, _ isDeleting: LoadableSubject<Void>) async
    func loadTemplates() async
}

struct RealMyTemplateListInteractor {

    private let templateRepository: TemplateRepository
    private let appState: AppState

    init(templateRepository: TemplateRepository = FirebaseTemplateRepository.shared,
         appState: AppState) {
        self.templateRepository = templateRepository
        self.appState = appState
    }

}

extension RealMyTemplateListInteractor: MyTemplateListInteractor {

    func addTemplate(template: Template) async {
        do {
            guard case Loadable<UserInfo>.loaded = appState.userData.userInfo else {
                appState.userData.myTemplateList = .needAuthentication
                return
            }
            try await templateRepository.addTemplate(template: template)
            var templates: [Template]? = appState.userData.myTemplateList.value
            templates?.append(template)
            appState.userData.myTemplateList = .loaded(templates ?? [template])
        } catch {
            appState.userData.myTemplateList = .failed(error)
        }
    }

    func changeTemplateVisibility(of template: Template, isChanging: LoadableSubject<Void>) async {
        do {
            isChanging.wrappedValue = .isLoading(last: nil)
            let changedTemplate = try await templateRepository.changeTemplateVisibility(of: template)
            guard var templates = appState.userData.myTemplateList.value else {
                isChanging.wrappedValue = .notRequested
                return
            }
            templates.replace(to: changedTemplate)
            appState.userData.myTemplateList = .loaded(templates)
            isChanging.wrappedValue = .loaded(())
        } catch {
            isChanging.wrappedValue = .failed(error)
        }
    }

    func deleteTemplate(_ template: Template, _ isDeleting: LoadableSubject<Void>) async {
        do {
            isDeleting.wrappedValue = .isLoading(last: nil)
            try await templateRepository.deleteTemplate(template)
            var value: [Template]? = appState.userData.myTemplateList.value
            value?.removeAll { $0.id == template.id }
            if let value = value {
                appState.userData.myTemplateList = .loaded(value)
            }
            isDeleting.wrappedValue = .loaded(())
        } catch {
            isDeleting.wrappedValue = .failed(error)
        }
    }

    func loadTemplates() async {
        do {
            appState.userData.myTemplateList = .isLoading(last: nil)
            // 유저 정보가 없다면, authentication 이 필요하다는 메시지를 띄움!
            guard let userInfo = appState.userData.userInfo.value else {
                appState.userData.myTemplateList = .needAuthentication
                return
            }
            let templates: [Template] = try await templateRepository.requestTemplates(of: String(userInfo.id))
            appState.userData.myTemplateList = .loaded(templates)
        } catch {
            appState.userData.myTemplateList = .failed(error)
        }
    }

}
