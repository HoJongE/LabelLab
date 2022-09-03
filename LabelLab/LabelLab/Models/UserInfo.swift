//
//  UserInfo.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

import Foundation

/// 유저 닉네임, 유저 프로필, 유저 이메일 등 추가 정보
struct UserInfo: Codable, Identifiable {
    let id: Int // 유저 id
    let nickname: String // 닉네임
    let profileImage: String? // 프로필 이미지 url
    let email: String? // 이메일

    private enum CodingKeys: String, CodingKey {
        case id
        case nickname = "login"
        case profileImage = "avatar_url"
        case email
    }
}

extension UserInfo: Equatable {
    static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        lhs.id == rhs.id && lhs.nickname == rhs.nickname && lhs.profileImage == rhs.profileImage && lhs.email == rhs.email
    }
}

extension UserInfo: CustomStringConvertible {
    var description: String {
        "닉네임: \(nickname) 이메일: \(email ?? "없음") 프로필 이미지: \(profileImage ?? "없음")"
    }
}
