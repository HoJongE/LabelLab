//
//  TemplateEditingInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/08.
//

import Foundation

protocol TemplateDetailInteractor {
    func updateTemplateName(of template: Template, to name: String) async
    func updateTemplateDescription(of template: Template, to description: String) async
    func addTag(to template: Template, tag: String) async
    func deleteTag(of template: Template, tag: String) async
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

    func updateTemplateName(of template: Template, to name: String) async {
        do {
            try await templateRepository.updateTemplateName(of: template, to: name)
        } catch {
            print(error.localizedDescription)
        }
    }

    func updateTemplateDescription(of template: Template, to description: String) async {
        do {
            try await templateRepository.updateTemplateDescription(of: template, to: description)
        } catch {
            print(error.localizedDescription)
        }
    }

    // TODO: Repository 구현 후 구현해야함
    func addTag(to template: Template, tag: String) async {
    }

    // TODO: Repository 구현 후 구현해야함
    func deleteTag(of template: Template, tag: String) async {
    }
}
