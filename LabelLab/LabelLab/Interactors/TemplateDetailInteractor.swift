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

    private let templateRepository: TemplateRepository
    private let appState: AppState

    init(templateRepository: TemplateRepository = FirebaseTemplateRepository.shared,
         appState: AppState) {
        self.templateRepository = templateRepository
        self.appState = appState
    }
}

extension RealTemplateDetailInteractor: TemplateDetailInteractor {

    func updateTemplateName(of template: Template, to name: String, completion: @escaping (Error?) -> Void) {
        templateRepository.updateTemplateName(of: template, to: name, completion: completion)
    }

    func updateTemplateDescription(of template: Template, to description: String, completion: @escaping (Error?) -> Void) {
        templateRepository.updateTemplateDescription(of: template, to: description, completion: completion)
    }

    // TODO: Repository 구현 후 구현해야함
    func addTag(to template: Template, tag: String, completion: @escaping (Error?) -> Void) {
    }

    // TODO: Repository 구현 후 구현해야함
    func deleteTag(of template: Template, tag: String, completion: @escaping (Error?) -> Void) {
    }
}
