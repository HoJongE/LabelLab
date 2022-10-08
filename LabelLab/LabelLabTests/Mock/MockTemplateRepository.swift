//
//  MockTemplateRepository.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/25.
//

@testable import LabelLab

final class MockTemplateRepository: TemplateRepository {

    private var templates: [Template] = []
    private var error: Error?

    init(_ error: Error? = nil) {
        self.error = error
    }

    func injectError(_ error: Error) {
        self.error = error
    }

    func addTemplate(template: LabelLab.Template) async throws {
        try throwError()
        templates.append(template)
    }

    func changeTemplateVisibility(of template: LabelLab.Template) async throws -> LabelLab.Template {
        try throwError()
        let changedTemplate: Template = template.changeVisibiltiy()
        templates.replace(to: changedTemplate)
        return changedTemplate
    }

    func deleteTemplate(_ template: LabelLab.Template) async throws {
        try throwError()
        templates.removeAll {
            $0.id == template.id
        }
    }

    func updateTemplateName(of template: LabelLab.Template, to name: String, completion: @escaping (Error?) -> Void) {

    }

    func updateTemplateDescription(of template: LabelLab.Template, to description: String, completion: @escaping (Error?) -> Void) {

    }

    func addTag(to template: LabelLab.Template, tag: String) async throws {

    }

    func deleteTag(of template: LabelLab.Template, tag: String) async throws {
        
    }

    func requestTemplates(of userId: String) async throws -> [LabelLab.Template] {
        try throwError()
        return templates
    }

    func deleteTemplates(of userId: String) async throws {
        try throwError()
        templates.removeAll()
    }

    private func throwError() throws {
        if let error {
            throw error
        }
    }
}
