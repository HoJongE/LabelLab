//
//  MockURLSession.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/08/29.
//

import Foundation
@testable import LabelLab

final class MockURLSession: URLSessionProtocol {

    private let dataToReturn: Data
    private let responseToReturn: URLResponse

    init(data: Data, response: URLResponse) {
        self.dataToReturn = data
        self.responseToReturn = response
    }

    func data(for: URLRequest) async throws -> (Data, URLResponse) {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return (dataToReturn, responseToReturn)
    }
}
