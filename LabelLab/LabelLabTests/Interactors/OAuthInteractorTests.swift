//
//  OAuthInteractorTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/08/29.
//

@testable import LabelLab
import KeyChainWrapper
import XCTest

final class OAuthInteractorTests: XCTestCase {

    private var oAuthInteractor: OAuthInteractor!
    private var appState: AppState!
    private var keychainManager: PasswordKeychainManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        appState = AppState.preview
        let mockURLSession: MockURLSession = MockURLSession(data: Data(), response: URLResponse())
        let oAuthService: OAuthService = MockOAuthService(mockURLSession)
        oAuthInteractor = RealOAuthInteractor(oAuthService: oAuthService, appState: appState)
        keychainManager = PasswordKeychainManager(service: Bundle.main.bundleIdentifier!)
    }

    override func tearDown() async throws {
        try await super.tearDown()
        try await keychainManager.removeAllPassword()
        keychainManager = nil
        oAuthInteractor = nil
        appState = nil
    }

    func testOpenOAuthSite() {
        oAuthInteractor.openOAuthSite()
        XCTAssert(true, "open OAuth Site success")
    }

    func testRequestAccessToken() async throws {
        await oAuthInteractor.requestAccessToken()
        let accessToken = try await keychainManager.getPassword(for: KeychainConst.accessToken)
        XCTAssert(true, "request Access Token test success")
        XCTAssertEqual(accessToken, "gho_16C7e42F292c6912E7710c838347Ae178B4a")
    }

    func testRequestUserInfo() async {
        XCTAssertEqual(appState.userData.userInfo, Loadable<UserInfo>.notRequested)
        await oAuthInteractor.requestUserInfo()
        XCTAssertEqual(appState.userData.userInfo, Loadable<UserInfo>.loaded(UserInfo.hojonge))
    }

    func testLogout() async throws {
        await oAuthInteractor.requestAccessToken()
        var accessToken = try await keychainManager.getPassword(for: KeychainConst.accessToken)
        XCTAssertEqual(accessToken, "gho_16C7e42F292c6912E7710c838347Ae178B4a")
        await oAuthInteractor.logout()
        accessToken = try await keychainManager.getPassword(for: KeychainConst.accessToken)
        XCTAssertNil(accessToken)
        XCTAssertEqual(appState.userData.userInfo, .notRequested)
    }

}
