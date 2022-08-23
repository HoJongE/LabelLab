//
//  OAuthAuthenticatorTest.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/08/23.
//

@testable import LabelLab
import XCTest

final class OAuthAuthenticatorTest: XCTestCase {

    private var oAuthService: OAuthService!
    override func setUpWithError() throws {
        oAuthService = LabelLab.GithubOAuthService()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        oAuthService = nil
    }

    func testOpenOAuthSite() throws {
        oAuthService.openOAuthSite()
    }

}
