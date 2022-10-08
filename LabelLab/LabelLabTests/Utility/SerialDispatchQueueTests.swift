//
//  SerialDispatchQueueTests.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/10/08.
//

@testable import LabelLab
import XCTest

final class SerialDispatchQueueTests: XCTestCase {

    private var serialQueue: SerialTasksDispatchQueue!

    actor TestClass {
        var arr: [Int] = []

        func getArr() -> [Int] {
            arr
        }

        func append(_ number: Int) {
            arr.append(number)
        }
    }

    override func setUp() {
        super.setUp()
        serialQueue = .init()
    }

    override func tearDown() {
        serialQueue = nil
        super.tearDown()
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
            print(arr)
            XCTAssertEqual(arr, Array(0...90))
            promise10.fulfill()
        }
        wait(for: [promise10], timeout: 20)
    }

    private func addTask(_ testClass: TestClass, _ promise: XCTestExpectation, range: ClosedRange<Int>) {
        serialQueue.addTask {
            print("task start!")
            for i in range {
                await testClass.append(i)
            }
            promise.fulfill()
        }
    }
}
