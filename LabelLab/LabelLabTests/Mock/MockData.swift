//
//  MockData.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/08.
//

@testable import LabelLab

extension GithubRepository {
    static var testRepository: GithubRepository {
        GithubRepository(id: 1, name: "Test", fullName: "HoJongE/Test", labelsURL: "https://github.com/HoJongE/Test/labels", owner: .hojonge, isPrivate: true, repositoryDescription: "")
    }
}
