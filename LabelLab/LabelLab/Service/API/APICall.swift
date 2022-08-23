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
        let urlComponents: URLComponents? = URLComponents(string: baseURL + path)
        guard var urlComponents = urlComponents else { return nil }
        var queryItems: [URLQueryItem] = []
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

}
