//
//  TemplateDetailInteractorTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/10/09.
//

@testable import LabelLab
import XCTest

final class TemplateDetailInteractorTests: XCTestCase {

    private var appState: AppState!
    private var interactor: TemplateDetailInteractor!
    private var templateRepository: MockTemplateRepository!
    private var templateToUpdate: Template!

    override func setUp() async throws {
        try await super.setUp()
        templateToUpdate = Template.mockedData.first!
        appState = AppState()
        templateRepository = MockTemplateRepository()
        interactor = RealTemplateDetailInteractor(templateRepository: templateRepository, appState: appState)
    }

    override func tearDown() async throws {
        templateToUpdate = nil
        appState = nil
        templateRepository = nil
        interactor = nil
        try await super.tearDown()
    }

    func testUpdateTemplateName() {
        appState.userData.myTemplateList = .loaded([templateToUpdate])
        let name: String = "Mirror Mirror on the wall"
        interactor.updateTemplateName(of: templateToUpdate, to: name, completion: { _ in })
        XCTAssertEqual(appState.userData.myTemplateList.value?.first?.name, name)
    }

    func testUpdateTemplateNameFail() {
        templateRepository.injectError(OAuthError.dataNotExist)
        appState.userData.myTemplateList = .loaded([templateToUpdate])
        let name: String = "Mirror Mirror on the wall"
        interactor.updateTemplateName(of: templateToUpdate, to: name, completion: { _ in })
        XCTAssertNotEqual(name, appState.userData.myTemplateList.value?.first?.name)
    }

    func testUpdateTemplateDescription() {
        appState.userData.myTemplateList = .loaded([templateToUpdate])
        let description: String = "Mirror Mirror on the wall"
        interactor.updateTemplateDescription(of: templateToUpdate, to: description, completion: { _ in })
        XCTAssertEqual(description, appState.userData.myTemplateList.value?.first?.templateDescription)
    }

    func testUpdateTemplateDescriptionFail() {
        templateRepository.injectError(OAuthError.dataNotExist)
        appState.userData.myTemplateList = .loaded([templateToUpdate])
        let description: String = "Mirror Mirror on the wall"
        interactor.updateTemplateDescription(of: templateToUpdate, to: description, completion: { _ in })
        XCTAssertNotEqual(appState.userData.myTemplateList.value?.first?.templateDescription, description)
    }
}
