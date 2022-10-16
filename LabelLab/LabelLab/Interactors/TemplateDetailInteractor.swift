//
//  TemplateEditingInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/08.
//

import Foundation

protocol TemplateDetailInteractor {
    func updateTemplateName(of template: Template, to name: String, completion: @escaping (Error?) -> Void)
    func updateTemplateDescription(of template: Template, to description: String, completion: @escaping (Error?) -> Void)
    func addTag(to template: Template, tag: String, completion: @escaping (Error?) -> Void)
    func deleteTag(of template: Template, tag: String, completion: @escaping (Error?) -> Void)
}

struct RealTemplateDetailInteractor {

    private let templateRepository: MyTemplateRepository
    private let appState: AppState

    init(templateRepository: MyTemplateRepository = FirebaseMyTemplateRepository.shared,
         appState: AppState) {
        self.templateRepository = templateRepository
        self.appState = appState
    }
}

extension RealTemplateDetailInteractor: TemplateDetailInteractor {

    func updateTemplateName(of template: Template, to name: String, completion: @escaping (Error?) -> Void) {
        templateRepository.updateTemplateName(of: template, to: name) { error in
            if error == nil {
                var value: [Template]? = appState.userData.myTemplateList.value
                value?.replace(to: template.changeName(to: name))
                guard let value else { return }
                appState.userData.myTemplateList = .loaded(value)
            }
            completion(error)
        }
    }

    func updateTemplateDescription(of template: Template, to description: String, completion: @escaping (Error?) -> Void) {
        templateRepository.updateTemplateDescription(of: template, to: description) { error in
            if error == nil {
                var value: [Template]? = appState.userData.myTemplateList.value
                value?.replace(to: template.changeDescription(to: description))
                guard let value else { return }
                appState.userData.myTemplateList = .loaded(value)
            }
            completion(error)
        }
    }

    // TODO: Repository 구현 후 구현해야함
    func addTag(to template: Template, tag: String, completion: @escaping (Error?) -> Void) {
    }

    // TODO: Repository 구현 후 구현해야함
    func deleteTag(of template: Template, tag: String, completion: @escaping (Error?) -> Void) {
    }
}
