//
//  Repository.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/03.
//

import Foundation

struct GithubRepository: Codable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let labelsURL: String
    let owner: UserInfo
    let isPrivate: Bool
    let repositoryDescription: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case labelsURL = "labels_url"
        case owner
        case isPrivate = "private"
        case repositoryDescription = "description"
    }
}

extension GithubRepository: Equatable {
    static func == (lhs: GithubRepository, rhs: GithubRepository) -> Bool {
        return lhs.id == rhs.id
    }
}

extension GithubRepository: CustomStringConvertible {
    var description: String {
        "저장소 이름: \(name) 주인: \(owner.nickname) 설명: \(repositoryDescription)"
    }
}
