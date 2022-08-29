//
//  OAuthInteractorTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/08/29.
//

@testable import LabelLab
import XCTest

final class OAuthInteractorTests: XCTestCase {

    private var oAuthInteractor: OAuthInteractor!
    private var appState: AppState!

    override func setUpWithError() throws {
        try super.setUpWithError()
        appState = AppState.preview
        let mockURLSession: MockURLSession = MockURLSession(data: Data(), response: URLResponse())
        let oAuthService: OAuthService = MockOAuthService(mockURLSession)
        oAuthInteractor = RealOAuthInteractor(oAuthService: oAuthService, appState: appState)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        oAuthInteractor = nil
        appState = nil
    }

    func testOpenOAuthSite() {
        oAuthInteractor.openOAuthSite()
        XCTAssert(true, "open OAuth Site success")
    }

    func testRequestAccessToken() async {
        await oAuthInteractor.requestAccessToken()
        XCTAssert(true, "request Access Token test success")
    }

    func testRequestUserInfo() async {
        XCTAssertEqual(appState.userData.userInfo, Loadable<UserInfo>.notRequested)
        await oAuthInteractor.requestUserInfo()
        XCTAssertEqual(appState.userData.userInfo, Loadable<UserInfo>.loaded(UserInfo.hojonge))
    }

}
