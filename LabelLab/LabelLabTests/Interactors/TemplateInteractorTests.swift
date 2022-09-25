//
//  TemplateRepositoryTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/25.
//

@testable import LabelLab
import XCTest

final class TemplateInteractorTests: XCTestCase {

    private var interactor: MyTemplateListInteractor!
    private var templateRepository: MockTemplateRepository!
    private var appState: AppState!
    override func setUp() async throws {
        try await super.setUp()
        templateRepository = MockTemplateRepository()
        appState = AppState()
        interactor = RealMyTemplateListInteractor(templateRepository: templateRepository, appState: appState)
    }

    override func tearDown() async throws {
        templateRepository = nil
        appState = nil
        interactor = nil
        try await super.tearDown()
    }

    // 유저데이터가 없을 때 정상적으로 needAuthentication 상태로 되는지 확인하는 테스트
    func testRequestTemplatesWhenUserDataIsNil() async {
        await interactor.loadTemplates()
        XCTAssertEqual(appState.userData.myTemplateList, .needAuthentication)
    }

    // 에러를 던지면 정상적으로 templateData 가 error 상태로 되는지 확인하는 테스트
    func testRequestTemplatesThrowError() async {
        appState.userData.userInfo = .loaded(.hojonge)
        templateRepository.injectError(OAuthError.userInfoNotExist)
        await interactor.loadTemplates()
        XCTAssertNotNil(appState.userData.myTemplateList.error)
    }

    // 템플릿이 정상적으로 로드 되는지 확인!
    func testRequestTemplatesSuccess() async {
        appState.userData.userInfo = .loaded(.hojonge)
        for template in Template.mockedData {
            try? await templateRepository.addTemplate(template: template)
        }
        await interactor.loadTemplates()

        XCTAssertEqual(appState.userData.myTemplateList.value, Template.mockedData)
    }

    // 템플릿 삭제 메소드가 정상적으로 에러를 방출하고, 삭제 이벤트가 failed 되는지 확인하는 테스트!
    func testDeleteTemplateThrowError() async {
        // given
        templateRepository.injectError(OAuthError.userInfoNotExist)
        let isDeleting: BindingWrapper<Loadable<Void>> = .init(value: .notRequested)
        let templateToDelete: Template = Template.mockedData.first!
        // when
        try? await templateRepository.addTemplate(template: templateToDelete)
        await interactor.deleteTemplate(templateToDelete, isDeleting.binding)
        // then
        XCTAssertNotNil(isDeleting.value.error)
    }

    // 템플릿 삭제 메소드가 정상적으로 성공하고, 삭제 이벤트가 complete 되는지 확인하는 테스트!
    func testDeleteTemplateSuccess() async {
        // given
        let templateToDelete: Template = Template.mockedData.first!
        try? await templateRepository.addTemplate(template: templateToDelete)
        let isDeleting: BindingWrapper<Loadable<Void>> = .init(value: .notRequested)
        // when
        await interactor.deleteTemplate(templateToDelete, isDeleting.binding)
        // then
        XCTAssertNotNil(isDeleting.value.value)
    }
}
