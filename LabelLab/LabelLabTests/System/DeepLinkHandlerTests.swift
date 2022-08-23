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

    override func setUpWithError() throws {
        try super.setUpWithError()
        deepLinkHandler = RealDeepLinkHandler()
    }

    override func tearDownWithError() throws {
        deepLinkHandler = nil
        try super.tearDownWithError()
    }

    /// Authorize Code deep link 가 authorize code 와 알맞은 enum case 로 변환되었는지 확인하는 테스트
    func testDeepLinkIsAuthorizeLinkWithCorrectCode() throws {
        // given
        var deepLink: DeepLink?
        let testURL: URL? = URL(string: "")
        // when
        guard let testURL = testURL else { XCTFail("Test URL should not be nil")}
        deepLink = DeepLink(testURL)
        // then
        XCTAssertEqual(deepLink, DeepLink.authorizeCode)
    }
}
