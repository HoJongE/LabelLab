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
        let promise3 = expectation(description: #function + "Third Task")
        let promise4 = expectation(description: #function + "4 Task")
        let promise5 = expectation(description: #function + "5 Task")
        let promise6 = expectation(description: #function + "6 Task")
        let promise7 = expectation(description: #function + "7 Task")
        let promise8 = expectation(description: #function + "8 Task")
        let promise9 = expectation(description: #function + "9 Task")
        let promise10 = expectation(description: #function + "Certificate")

        addTask(testClass, promise1, range: 0...10)
        addTask(testClass, promise2, range: 11...20)
        addTask(testClass, promise3, range: 21...30)
        addTask(testClass, promise4, range: 31...40)
        addTask(testClass, promise5, range: 41...50)
        addTask(testClass, promise6, range: 51...60)
        addTask(testClass, promise7, range: 61...70)
        addTask(testClass, promise8, range: 71...80)
        addTask(testClass, promise9, range: 81...90)

        wait(for: [promise1, promise2, promise3, promise4, promise5, promise6, promise7, promise8, promise9], timeout: 10)

        Task { [testClass] in
            let arr = await testClass.getArr()
            XCTAssertEqual(arr, Array(0...90))
            promise10.fulfill()
        }
        wait(for: [promise10], timeout: 20)
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

    private func addTask(_ testClass: TestClass, _ promise: XCTestExpectation, range: ClosedRange<Int>) {
        Task {
            await serialTasks.add {
                for i in range {
                    await testClass.append(i)
                }
                promise.fulfill()
            }
        }
    }
}
