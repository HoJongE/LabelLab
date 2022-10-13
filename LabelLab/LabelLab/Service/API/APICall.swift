//
//  APICall.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

import Foundation

typealias Headers = [String: String]
typealias Parameters = [String: String]

protocol APICall {
    var path: String { get }
    var method: String { get }
    var headers: Headers { get }
    var parameters: Parameters { get }
    var baseURL: String { get }
}

extension APICall {

    var url: URL? {
        guard let encoded = (baseURL + path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encoded) else { return nil }
        let urlComponents: URLComponents? = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard var urlComponents = urlComponents else { return nil }
        var queryItems: [URLQueryItem] = []
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        if !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }
        return urlComponents.url
    }

    func request(with session: URLSessionProtocol = URLSession.shared) async throws -> (data: Data, response: URLResponse) {
        guard let url = url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        _ = headers.map { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return try await session.data(for: request, delegate: nil)
    }

    func post(with session: URLSessionProtocol = URLSession.shared, data: Data, delegate: URLSessionTaskDelegate? = nil) async throws -> (data: Data, response: URLResponse) {
        guard let url = url else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = data
        _ = headers.map { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return try await session.data(for: request, delegate: delegate)
    }

}
