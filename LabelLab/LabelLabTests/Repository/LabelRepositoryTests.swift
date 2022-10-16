//
//  LabelRepositoryTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/10/10.
//

@testable import LabelLab
import XCTest

final class LabelRepositoryTests: XCTestCase {

    private var labelRepository: LabelRepository!
    private var templateRepository: MyTemplateRepository!
    private let testTemplate: Template = Template.mockedData.first!
    private let testLabel: Label = Label.mockedData.first!

    override func setUp() async throws {
        try await super.setUp()
        labelRepository = FirebaseLabelRepository.shared
        templateRepository = FirebaseMyTemplateRepository.shared
        try await templateRepository.addTemplate(template: testTemplate)
    }

    override func tearDown() async throws {
        try await templateRepository.deleteTemplate(testTemplate)
        templateRepository = nil
        labelRepository = nil
        try await super.tearDown()
    }

    func testAddLabelToTemplate() async {
        do {
            try await labelRepository.addLabel(to: testTemplate, label: testLabel)
            let labels: [Label] = try await labelRepository.requestLabels(of: testTemplate)
            XCTAssertEqual(labels.count, 1)
            XCTAssertEqual(labels.first!, testLabel)
        } catch {
            XCTFail(#function + error.localizedDescription)
        }
    }

    func testDeleteLabel() async {
        do {
            try await labelRepository.addLabel(to: testTemplate, label: testLabel)
            let labelCount: Int = try await labelRepository.requestLabels(of: testTemplate).count
            XCTAssertEqual(labelCount, 1)
            try await labelRepository.deleteLabel(of: testTemplate, label: testLabel)
            let deletedLabelCount: Int = try await labelRepository.requestLabels(of: testTemplate).count
            XCTAssertEqual(deletedLabelCount, 0)
        } catch {
            XCTFail(#function + error.localizedDescription)
        }
    }

    func testModifyLabel() async {
        do {
            try await labelRepository.addLabel(to: testTemplate, label: testLabel)
            let modifiedLabel: Label = Label(id: testLabel.id, name: "테스트용으로변경", labelDescription: "테스트용으로변경", hex: "000000")
            try await labelRepository.modifyLabel(to: testTemplate, label: modifiedLabel)
            let labels: [Label] = try await labelRepository.requestLabels(of: testTemplate)
            // 라벨이 정상적으로 하나만 추가되었는지 확인
            XCTAssertEqual(labels.count, 1)
            // 라벨이 정상적으로 수정된 라벨로 업데이트되었는지 확인
            XCTAssertEqual(modifiedLabel, labels.first)
            // 라벨이 정상적으로 수정된 라벨로 업데이트되서, 기존 라벨과 일치하지 않는지 확인
            XCTAssertNotEqual(testLabel, labels.first)
        } catch {
            XCTFail(#function + error.localizedDescription)
        }
    }
}
