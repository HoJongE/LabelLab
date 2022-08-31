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
        let mockURLSession: URLSessionProtocol = MockURLSession(data: GithubAPI.accessTokenResult, response: URLResponse())
        oAuthService = GithubOAuthService(mockURLSession)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        oAuthService = nil
    }

    func testOpenOAuthSite() throws {
        oAuthService.openOAuthSite()
        XCTAssert(true)
    }

    func testRequestAccessToken() async throws {
        // given
        var accessToken: AccessToken?
        // when
        accessToken = try await oAuthService.requestAccessToken(with: "")
        // then
        XCTAssertEqual(accessToken, "gho_16C7e42F292c6912E7710c838347Ae178B4a")
    }

    func testRequestAccessTokenFailWhenDataIsEmpty() async {
        // given
        let urlSession: URLSessionProtocol = MockURLSession(data: Data(), response: URLResponse())
        oAuthService = GithubOAuthService(urlSession)

        // when
        do {
            _ = try await oAuthService.requestAccessToken(with: "")
            XCTFail("Should not pass test because data is empty")
        } catch {
            // then
            XCTAssertEqual(OAuthServiceError.dataNotExist.recoverySuggestion, (error as? OAuthServiceError)?.recoverySuggestion)
            XCTAssertEqual(OAuthServiceError.dataNotExist.errorDescription, (error as? OAuthServiceError)?.errorDescription)
            XCTAssertEqual(OAuthServiceError.dataNotExist, error as? OAuthServiceError)
        }
    }

    func testRequestAccessTokenFailWhenDataIsMalformed() async {
        // given
        let urlSession: URLSessionProtocol = MockURLSession(data: Data(
            """
            {
                "malformedData": "Yes!"
            }
            """.utf8
        ), response: URLResponse())
        oAuthService = GithubOAuthService(urlSession)

        // when
        do {
            _ = try await oAuthService.requestAccessToken(with: "")
            XCTFail("Should not pass test because data is malformed")
        } catch {
            // then
            XCTAssertEqual(OAuthServiceError.tokenNotExist.recoverySuggestion, (error as? OAuthServiceError)?.recoverySuggestion)
            XCTAssertEqual(OAuthServiceError.tokenNotExist.errorDescription, (error as? OAuthServiceError)?.errorDescription)
            XCTAssertEqual(OAuthServiceError.tokenNotExist, error as? OAuthServiceError)
        }
    }

    func testRequestUserInfo() async throws {
        // given
        var userInfo: UserInfo?
        // when
        userInfo = try await oAuthService.requestUserInfo()
        // then
        XCTAssertNotNil(userInfo)
    }

}
