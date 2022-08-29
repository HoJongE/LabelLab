//
//  MockURLData.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/08/29.
//

import Foundation
@testable import LabelLab

extension GithubAPI {
    static var accessTokenResult: Data {
        Data(
            """
        {
          "access_token":"gho_16C7e42F292c6912E7710c838347Ae178B4a",
          "scope":"repo,gist",
          "token_type":"bearer"
        }
        """.utf8)
    }
}
