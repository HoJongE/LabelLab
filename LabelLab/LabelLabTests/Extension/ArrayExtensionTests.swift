//
//  ArrayExtensionTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/25.
//

@testable import LabelLab
import XCTest

final class ArrayExtensionTests: XCTestCase {

    func testReplaceSucceed() {
        // given
        var templates: [Template] = Template.mockedData
        let replace = templates.first!
        let newTemplate = Template(id: replace.id, name: replace.name, templateDescription: replace.templateDescription, makerId: replace.makerId, copyCount: replace.copyCount, tag: replace.tag, isOpen: !replace.isOpen)

        // when
        templates.replace(to: newTemplate)
        let replacedTemplate = templates.first!
        // then
        XCTAssertEqual(newTemplate, replacedTemplate)
    }

    func testReplaceFailed() {
        var templates: [Template] = Template.mockedData
        let newTemplate = Template(id: "weird", name: "", templateDescription: "", makerId: "123", copyCount: 0, tag: [], isOpen: false)
        templates.replace(to: newTemplate)

        XCTAssert(!templates.contains(newTemplate))
    }

    func testDeleteElementSucceed() {
        var templates: [Template] = Template.mockedData
        let templateToDelete = templates.first!
        templates.delete(templateToDelete)
        XCTAssert(!templates.contains(templateToDelete))
    }

    func testDeleteElementFailed() {
        let templates: [Template] = Template.mockedData
        var secondTemplates: [Template] = Template.mockedData
        let dummyTemplate: Template = .init(id: "없는아이디", name: "", templateDescription: "", makerId: "", copyCount: 0, tag: [], isOpen: false)
        secondTemplates.delete(dummyTemplate)

        XCTAssertEqual(templates, secondTemplates)
    }
}
