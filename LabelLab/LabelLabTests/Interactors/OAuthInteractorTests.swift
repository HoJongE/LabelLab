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
        let accessToken = try await keychainManager.getPassword(for: KeychainConst.accessToken)
        XCTAssert(true, "request Access Token test success")
        XCTAssertEqual(accessToken, ConstantData.accessToken)
    }

    func testRequestUserInfo() async throws {
        XCTAssertEqual(appState.userData.userInfo, Loadable<UserInfo>.notRequested)
        try await keychainManager.savePassword("", for: KeychainConst.accessToken)
        await oAuthInteractor.requestUserInfo()
        XCTAssertEqual(appState.userData.userInfo, Loadable<UserInfo>.loaded(UserInfo.hojonge))
    }

    func testLogout() async throws {
        await oAuthInteractor.requestAccessToken(with: "")
        var accessToken = try await keychainManager.getPassword(for: KeychainConst.accessToken)
        XCTAssertEqual(accessToken, ConstantData.accessToken)
        await oAuthInteractor.logout()
        accessToken = try await keychainManager.getPassword(for: KeychainConst.accessToken)
        XCTAssertNil(accessToken)
        XCTAssertEqual(appState.userData.userInfo, .notRequested)
    }

}
