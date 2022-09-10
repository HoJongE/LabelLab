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
        let mockURLSession: URLSessionProtocol = MockURLSession(data: GithubAuthAPI.accessTokenResult, response: URLResponse())
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
        XCTAssertEqual(accessToken, ConstantData.accessToken)
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
            XCTAssertEqual(OAuthError.dataNotExist.recoverySuggestion, (error as? OAuthError)?.recoverySuggestion)
            XCTAssertEqual(OAuthError.dataNotExist.errorDescription, (error as? OAuthError)?.errorDescription)
            XCTAssertEqual(OAuthError.dataNotExist, error as? OAuthError)
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
            XCTAssertEqual(OAuthError.tokenNotExist.recoverySuggestion, (error as? OAuthError)?.recoverySuggestion)
            XCTAssertEqual(OAuthError.tokenNotExist.errorDescription, (error as? OAuthError)?.errorDescription)
            XCTAssertEqual(OAuthError.tokenNotExist, error as? OAuthError)
        }
    }

    func testRequestUserInfo() async throws {
        // given
        var userInfo: UserInfo?
        let mockURLSession = MockURLSession(data: GithubAuthAPI.githubUserInfo, response: URLResponse())
        oAuthService = GithubOAuthService(mockURLSession)
        // when
        userInfo = try await oAuthService.requestUserInfo()
        // then
        XCTAssertEqual(UserInfo(id: 1, nickname: "octocat", profileImage: "https://github.com/images/error/octocat_happy.gif", email: "octocat@github.com"), userInfo)
    }

}
