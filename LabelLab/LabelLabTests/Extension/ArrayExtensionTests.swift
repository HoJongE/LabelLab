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
        templates.replace(newTemplate)
        let replacedTemplate = templates.first!
        // then
        XCTAssertEqual(newTemplate, replacedTemplate)
    }

    func testReplaceFailed() {
        var templates: [Template] = Template.mockedData
        let newTemplate = Template(id: "weird", name: "", templateDescription: "", makerId: "123", copyCount: 0, tag: [], isOpen: false)
        templates.replace(newTemplate)

        XCTAssert(!templates.contains(newTemplate))
    }
}
