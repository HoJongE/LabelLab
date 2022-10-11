//
//  LabelListInteractorTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/10/11.
//

@testable import LabelLab
import XCTest

final class LabelListInteractorTests: XCTestCase {

    private var interactor: LabelListInteractor!
    private var templateRepository: MockTemplateRepository!
    private var labelRepository: LabelRepository!
    private let templateToTest: Template = Template.mockedData.first!
    private var appState: AppState!

    override func setUp() async throws {
        try await super.setUp()
        templateRepository = MockTemplateRepository()
        labelRepository = MockLabelRepository()
        appState = AppState()
        interactor = RealLabelListInteractor(templateRepository: templateRepository, labelRepository: labelRepository, appState: appState)
    }

    override func tearDown() async throws {
        templateRepository = nil
        labelRepository = nil
        appState = nil
        interactor = nil
        try await super.tearDown()
    }

    func testRequestLabelSuccess() async {
        let labelsBinding: BindingWrapper<Loadable<[Label]>> = .init(value: .notRequested)
        await interactor.requestLabels(of: templateToTest, to: labelsBinding.binding)
        switch labelsBinding.value {
        case .loaded(let value):
            XCTAssertEqual(value.count, 0)
        default:
            XCTFail(#function + "fail")
        }
    }

    func testAddLabelSuccess() async {
        let labelsBinding: BindingWrapper<Loadable<[Label]>> = .init(value: .loaded([]))
        let labelToAdd: Label = Label(id: "꺼져", name: "존재 자체가 부전승", labelDescription: "나한테 서바이벌", hex: "살아남기")
        await interactor.addLabel(to: templateToTest, labelToAdd, labels: labelsBinding.binding)
        switch labelsBinding.value {
        case .loaded(let value):
            XCTAssertEqual([labelToAdd], value)
        default:
            XCTFail(#function + "fail")
        }
    }

    func testModifyLabelSuccess() async {
        let labelToModify: Label = Label(id: "꺼져", name: "존재 자체가 부전승", labelDescription: "나한테 서바이벌", hex: "살아남기")
        let labelsBinding: BindingWrapper<Loadable<[Label]>> = .init(value: .loaded([labelToModify]))
        let modifiedLabel: Label = Label(id: "꺼져", name: "후샛", labelDescription: "애니모", hex: "후후")
        await interactor.modifyLabel(of: templateToTest, modifiedLabel, labels: labelsBinding.binding)
        switch labelsBinding.value {
        case .loaded(let label):
            XCTAssertEqual([modifiedLabel], label)
        default:
            XCTFail(#function + "fail")
        }
    }

    func testDeleteLabelSuccess() async {
        let labelToDelete: Label = Label.mockedData.first!
        let labelsBinding: BindingWrapper<Loadable<[Label]>> = .init(value: .loaded([labelToDelete]))
        await interactor.deleteLabel(of: templateToTest, labelToDelete, labels: labelsBinding.binding)
        switch labelsBinding.value {
        case .loaded(let value):
            XCTAssertEqual([], value)
        default:
            XCTFail(#function + "fail")
        }
    }

}
