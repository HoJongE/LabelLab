//
//  TemplateRepositoryTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/10/16.
//

@testable import LabelLab
import XCTest

final class TemplateRepositoryTests: XCTestCase {

    private var templateRepository: TemplateRepository!
    private var myTemplateRepository: MyTemplateRepository!
    private var labelRepository: LabelRepository!
    private lazy var testTemplate: Template = Template(id: UUID().uuidString, name: "Test template", templateDescription: "", makerId: testUserId, copyCount: 0, tag: [], isOpen: true)
    private let testUserId: String = "testUserId"
    private lazy var testTemplates: [Template] = {
        var ret: [Template] = []

        for i in 0..<5 {
            ret.append(Template(id: UUID().uuidString, name: "Test Template", templateDescription: "Test Template", makerId: testUserId, copyCount: i, tag: [], isOpen: true))
        }

        for i in 0..<1 {
            ret.append(Template(id: UUID().uuidString, name: "Test Template", templateDescription: "Test Template", makerId: testUserId, copyCount: i, tag: [], isOpen: false))
        }
        return ret
    }()

    override func setUp() async throws {
        try await super.setUp()
        templateRepository = FirebaseTemplateRepository.shared
        myTemplateRepository = FirebaseMyTemplateRepository.shared
        labelRepository = FirebaseLabelRepository.shared
    }

    override func tearDown() async throws {
        try await myTemplateRepository.deleteTemplates(of: testUserId)
        try await myTemplateRepository.deleteTemplates(of: "copyUserId")
        myTemplateRepository = nil
        templateRepository = nil
        try await super.tearDown()
    }

    func testPaginationWithDescendingIsSuccess() async {
        do {
            try await templateRepository.addTemplates(templates: testTemplates)
            let query: TemplateQuery = .init(perPage: 2)

            let result1: [Template] = try await templateRepository.requestTemplates(exclude: "123", query: query).0
            XCTAssertEqual(result1.count, 2)
            XCTAssertEqual(result1.first!.copyCount, 4)
            let result2: [Template] = try await templateRepository.requestTemplates(exclude: "123", query: query).0
            XCTAssertEqual(result2.count, 2)
            XCTAssertEqual(result2.first!.copyCount, 2)
            let result3: [Template] = try await templateRepository.requestTemplates(exclude: "123", query: query).0
            XCTAssertEqual(result3.count, 1)
            XCTAssertEqual(result3.first!.copyCount, 0)

            let result4: [Template] = try await templateRepository.requestTemplates(exclude: "123", query: query).0
            XCTAssert(result4.isEmpty)
        } catch {
            XCTFail(#function + " \(error.localizedDescription)")
        }
    }

    func testPaginationWithAscendingIsSuccess() async {
        do {
            try await templateRepository.addTemplates(templates: testTemplates)
            let query: TemplateQuery = .init(descending: false, perPage: 2)

            let result1: [Template] = try await templateRepository.requestTemplates(exclude: "123", query: query).0
            XCTAssertEqual(result1.count, 2)
            XCTAssertEqual(result1.first!.copyCount, 0)
            let result2: [Template] = try await templateRepository.requestTemplates(exclude: "123", query: query).0
            XCTAssertEqual(result2.count, 2)
            XCTAssertEqual(result2.first!.copyCount, 2)
            let result3: [Template] = try await templateRepository.requestTemplates(exclude: "123", query: query).0
            XCTAssertEqual(result3.count, 1)
            XCTAssertEqual(result3.first!.copyCount, 4)

            let result4: [Template] = try await templateRepository.requestTemplates(exclude: "123", query: query).0
            XCTAssert(result4.isEmpty)
        } catch {
            XCTFail(#function + " \(error.localizedDescription)")
        }
    }

    func testCopyTemplate() async {
        do {
            // given
            let labelsToCopy: [Label] = Label.mockedData // 복사할 라벨
            // when
            try await myTemplateRepository.addTemplate(template: testTemplate)// 먼저 복사할 템플릿을 추가함
            try await labelRepository.addLabels(to: testTemplate, labels: labelsToCopy) // 그 다음 템플릿에 라벨을 추가함

            _ = try await templateRepository.copyTemplate(testTemplate, to: "copyUserId") // 그 다음 템플릿을 복사한다.

            guard let copiedTemplate: Template = try? await myTemplateRepository.requestTemplates(of: "copyUserId").first else { XCTFail(#function + " there should be one template that copied")
                return
            }
            let copiedLabels: [Label] = try await labelRepository.requestLabels(of: copiedTemplate)
            // then
            XCTAssertEqual(labelsToCopy.sorted(by: {
                $0.name > $1.name
            }), copiedLabels.sorted(by: {
                $0.name > $1.name
            }))
            XCTAssertNotEqual(testTemplate.id, copiedTemplate.id)
            XCTAssertNotEqual(testTemplate.makerId, copiedTemplate.makerId)
        } catch {
            XCTFail(#function + " \(error.localizedDescription)")
        }
    }
}
