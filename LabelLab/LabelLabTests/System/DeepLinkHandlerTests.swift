//
//  DeepLinkHandlerTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/08/23.
//

@testable import LabelLab
import XCTest

final class DeepLinkHandlerTests: XCTestCase {

    private var deepLinkHandler: DeepLinkHandler!
    private var appState: AppState!
    private var diContainer: DIContainer!

    override func setUpWithError() throws {
        try super.setUpWithError()
        appState = AppState()
        diContainer = MockDIContainerProvider.mockDIContainer(appState: appState)
        deepLinkHandler = RealDeepLinkHandler(diContainer, appState)
    }

    override func tearDownWithError() throws {
        deepLinkHandler = nil
        appState = nil
        diContainer = nil
        try super.tearDownWithError()
    }

    /// Authorize Code deep link 가 authorize code 와 알맞은 enum case 로 변환되었는지 확인하는 테스트
    func testDeepLinkIsAuthorizeLinkWithCorrectCode() throws {
        // given
        var deepLink: DeepLink?
        let testURL: URL? = URL(string: "labellab://login?code=1q2w3e4r")
        // when
        guard let testURL = testURL else { XCTFail("Test URL should not be nil"); return }
        deepLink = DeepLink(testURL)
        // then
        XCTAssertEqual(deepLink, DeepLink.authorize(authorizeCode: "1q2w3e4r"))
    }

    /// 변환 불가능한 Deep Link URL 이 들어왔을 때 성공적으로 실패하는지 확인하는 테스트
    func testDeepLinkIsNil() throws {
        // given
        var deepLink: DeepLink?
        let testURL: URL? = URL(string: "labellab://logew?coekwpofkow")
        // when
        guard let testURL = testURL else { XCTFail("Test URL should not be nil"); return }
        deepLink = DeepLink(testURL)
        // then
        XCTAssertNil(deepLink)
    }

    func testDeepLinkAccessTokenSuccess() async throws {
        // given
        let testURL: URL? = URL(string: "labellab://login?code=1q2w3e4r")

        guard let testURL = testURL, let deepLink = DeepLink(testURL) else {
            XCTFail("Test URL and deepLink should not be nil")
            return
        }

        // when
        await deepLinkHandler.open(deepLink)
        XCTAssertEqual(appState.userData.userInfo, Loadable.loaded(UserInfo.hojonge))
    }
}
