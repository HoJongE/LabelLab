//
//  SerialTaskTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/10/08.
//

@testable import LabelLab
import XCTest

final class SerialTaskTests: XCTestCase {

    private var serialTasks: SerialTasks<Void>!

    override func setUp() async throws {
        try await super.setUp()
        serialTasks = .init()
    }

    override func tearDown() async throws {
        serialTasks = nil
        try await super.tearDown()
    }

    actor TestClass {
        var arr: [Int] = []

        func getArr() -> [Int] {
            arr
        }

        func append(_ number: Int) {
            arr.append(number)
        }
    }

    func testTaskIsSerial() {
        let testClass: TestClass = TestClass()

        let promise1 = expectation(description: #function + "first Task")
        let promise2 = expectation(description: #function + "Second Task")
        let promise3 = expectation(description: #function + "Certificate")

        Task { [testClass] in
            await serialTasks.add {
                for i in 0...499 {
                    await testClass.append(i)
                }
                promise1.fulfill()
            }
        }
        Task { [testClass] in
            await serialTasks.add {
                for i in 500...1000 {
                    await testClass.append(i)
                }
                promise2.fulfill()
            }
        }

        wait(for: [promise1, promise2], timeout: 5)

        Task { [testClass] in
            let arr = await testClass.getArr()
            XCTAssertEqual(arr, Array(0...1000))
            promise3.fulfill()
        }
        wait(for: [promise3], timeout: 10)
    }

    func testTaskIsNotSerial() {
        let testClass: TestClass = TestClass()

        let promise1 = expectation(description: #function + "first Task")
        let promise2 = expectation(description: #function + "Second Task")
        let promise3 = expectation(description: #function + "Certificate")

        Task { [testClass] in
            for i in 0...499 {
                await testClass.append(i)
            }
            promise1.fulfill()
        }
        Task { [testClass] in
            for i in 500...1000 {
                await testClass.append(i)
            }
            promise2.fulfill()
        }

        wait(for: [promise1, promise2], timeout: 5)

        Task { [testClass] in
            let arr = await testClass.getArr()
            XCTAssertNotEqual(arr, Array(0...1000))
            promise3.fulfill()
        }
        wait(for: [promise3], timeout: 10)
    }
}
