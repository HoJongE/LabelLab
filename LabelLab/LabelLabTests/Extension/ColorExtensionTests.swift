//
//  ColorExtensionTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/10/09.
//

import SwiftUI
@testable import LabelLab
import XCTest

final class ColorExtensionTests: XCTestCase {

    func testBlackColorHexIsCorrect() {
        let color: Color = .black
        XCTAssertEqual(color.hex, "000000")
    }

    func testWhiteColorHexIsCorrect() {
        let color: Color = .white
        XCTAssertEqual(color.hex, "FFFFFF")
    }

    func testHexInitializerIsCorrect() {
        let color: Color = Color("ffffff")
        let whiteColor: Color = .white
        XCTAssertEqual(color.hex, whiteColor.hex)
    }
}
