//
//  URLCollection.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/23.
//

enum URLCollection {
    enum Github {
        static let GITHUB_AUTHENTICATE_BASE_URL: String = "https://github.com/login"
        static let GITHUB_AUTHORIZE: String = "/oauth/authorize"
        static let GITHUB_ACCESS_TOKEN: String = "/oauth/access_token"
        static let GITHUB_API_BASE_URL: String = "https://api.github.com/"
        static let GITHUB_GET_AUTHETICATED_USER: String = "user"
        static let GITHUB_GET_REPOSITORIES: String = "user/repos"
    }
}

