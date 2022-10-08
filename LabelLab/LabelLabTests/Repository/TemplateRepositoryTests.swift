//
//  TemplateRepositoryTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/24.
//

@testable import LabelLab
import XCTest

final class TemplateRepositoryTests: XCTestCase {

    let templateRepository: TemplateRepository = FirebaseTemplateRepository.shared
    let testUserId: String = "12345"
    lazy var template: Template = .init(id: "oboy", name: "", templateDescription: "", makerId: testUserId, copyCount: 0, tag: [], isOpen: false)
    override func setUp() async throws {
        try await super.setUp()
    }

    override func tearDown() async throws {
        try await templateRepository.deleteTemplates(of: testUserId)
        try await super.tearDown()
    }

    func testAddTemplateAndDeleteTemplate() async {
        do {
            try await templateRepository.addTemplate(template: template)
            let templates: [Template] = try await templateRepository.requestTemplates(of: testUserId)
            XCTAssertEqual(templates.first?.id, template.id)
            try await templateRepository.deleteTemplate(template)
            let emptyTemplates: [Template] = try await templateRepository.requestTemplates(of: testUserId)
            XCTAssert(emptyTemplates.isEmpty)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testChangeVisibility() async {
        do {
            try await templateRepository.addTemplate(template: template)
            _ = try await templateRepository.changeTemplateVisibility(of: template)
            let templates: [Template] = try await templateRepository.requestTemplates(of: testUserId)
            XCTAssertEqual(template.isOpen, !templates.first!.isOpen)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testUpdateName() async {
        do {
            let updateName: String = "Test Name!"
            try await templateRepository.addTemplate(template: template)
            try await templateRepository.updateTemplateName(of: template, to: updateName)
            let templates: [Template] = try await templateRepository.requestTemplates(of: testUserId)
            XCTAssertEqual(templates.count, 1)
            XCTAssertEqual(templates.first!.name, updateName)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testUpdateDescription() async {
        do {
            let updateDescription: String = "Test Description!"
            try await templateRepository.addTemplate(template: template)
            try await templateRepository.updateTemplateDescription(of: template, to: updateDescription)
            let templates: [Template] = try await templateRepository.requestTemplates(of: testUserId)
            XCTAssertEqual(templates.count, 1)
            XCTAssertEqual(templates.first!.templateDescription, updateDescription)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
