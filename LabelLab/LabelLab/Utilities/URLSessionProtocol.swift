//
//  URLSessionProtocol.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/29.
//

import Foundation

/// Mock URL Session 을 주입하기 위한 URLSessionProtocl, 기존 URLSession 의 async 함수인 data(for: URLRequest) 과 시그니처가 똑같은 함수를 프로토콜로 정의
protocol URLSessionProtocol {
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
}
