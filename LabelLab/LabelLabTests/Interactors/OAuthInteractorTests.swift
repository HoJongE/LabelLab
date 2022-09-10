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
        await oAuthInteractor.requestAccessToken(with: "")
        XCTAssert(true, "request Access Token test success")
    }

    func testRequestUserInfo() async throws {
        XCTAssertEqual(appState.userData.userInfo, Loadable<UserInfo>.notRequested)
        try await keychainManager.savePassword("", for: KeychainConst.accessToken)
        await oAuthInteractor.requestUserInfo()
        XCTAssertEqual(appState.userData.userInfo, Loadable<UserInfo>.loaded(UserInfo.hojonge))
    }

    func testLogout() async throws {
        await oAuthInteractor.requestAccessToken(with: "")
        await oAuthInteractor.requestUserInfo()
        XCTAssertEqual(appState.userData.userInfo, Loadable<UserInfo>.loaded(UserInfo.hojonge))
        await oAuthInteractor.logout()
        XCTAssertEqual(appState.userData.userInfo, .notRequested)
    }

}
