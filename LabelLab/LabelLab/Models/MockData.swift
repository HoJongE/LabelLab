//
//  MockData.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/19.
//

#if DEBUG
import Foundation

extension Template {
    static let mockedData: [Template] = [
        Template(id: UUID().uuidString, name: "IOS Procject Labels", templateDescription: "ios 프로젝트에 사용하는 템플릿입니다.", makerId: UUID().uuidString, copyCount: 10, tag: ["iOS", "project", "study"], isOpen: true),
        Template(id: UUID().uuidString, name: "Android Procject Labels", templateDescription: "Android 프로젝트에 사용하는 템플릿입니다.", makerId: UUID().uuidString, copyCount: 10, tag: [], isOpen: true),
        Template(id: UUID().uuidString, name: "Study Procject Labels", templateDescription: "스터디용 레포지토리에 사용하는 템플릿입니다.", makerId: UUID().uuidString, copyCount: 8, tag: [], isOpen: false),
        Template(id: UUID().uuidString, name: "LabelLab Procject Labels", templateDescription: "LabelLab 프로젝트에 사용하는 템플릿입니다.", makerId: UUID().uuidString, copyCount: 9, tag: [], isOpen: true),
        Template(id: UUID().uuidString, name: "Github basic template", templateDescription: "Github 기본 템플릿입니다.", makerId: UUID().uuidString, copyCount: 15, tag: [], isOpen: true),
        Template(id: UUID().uuidString, name: "Spring", templateDescription: "Spring 프로젝트에 사용하는 템플릿입니다.", makerId: UUID().uuidString, copyCount: 999, tag: [], isOpen: true),
        Template(id: UUID().uuidString, name: "SwiftUI Project", templateDescription: "SwiftUI 프로젝트에 사용하는 템플릿입니다.", makerId: UUID().uuidString, copyCount: 112, tag: [], isOpen: true),
        Template(id: UUID().uuidString, name: "UIKit Project", templateDescription: "UIKit 프로젝트에 사용하는 템플릿입니다.", makerId: UUID().uuidString, copyCount: 24, tag: [], isOpen: true),
        Template(id: UUID().uuidString, name: "Window os", templateDescription: "윈도우 os 프로젝트에 사용하는 템플릿입니다.", makerId: UUID().uuidString, copyCount: 35, tag: [], isOpen: true),
        Template(id: UUID().uuidString, name: "MacOS Procject Labels", templateDescription: "Mac os 프로젝트에 사용하는 템플릿입니다.", makerId: UUID().uuidString, copyCount: 1, tag: [], isOpen: true),
        Template(id: UUID().uuidString, name: "Joking", templateDescription: "장난용임", makerId: UUID().uuidString, copyCount: 0, tag: [], isOpen: true),
    ]
}

extension UserInfo {
    static let woody: UserInfo = UserInfo(id: 1, nickname: "우디", profileImage: "https://avatars.githubusercontent.com/u/56102421?v=4", email: "woody@gmail.com")

    static let hojonge: UserInfo = UserInfo(id: 2, nickname: "호종이", profileImage: "https://avatars.githubusercontent.com/u/57793298?s=400&u=c605ccc99eb0f6c7a2e4ac4f59c22b316532f2b8&v=4", email: "pjh00098@gmail.com")
    static let avery: UserInfo = UserInfo(id: 3, nickname: "에이버리", profileImage: nil, email: "avery@pos.idserve.com")
}

extension Label {
    static let mockedData: [Label] = [
        Label(id: UUID().uuidString, name: "feature", labelDescription: "기능을 구현하는 라벨", hex: "123456"),
        Label(id: UUID().uuidString, name: "refactoring", labelDescription: "리팩토링을 했을 때 붙일 수 있는 라벨입니다.", hex: "9dffa2"),
        Label(id: UUID().uuidString, name: "bug", labelDescription: "버그를 해결해주세요", hex: "ff9cc7"),
        Label(id: UUID().uuidString, name: "design", labelDescription: "디자인만 수정되었을 때", hex: "f17bff"),
        Label(id: UUID().uuidString, name: "chore", labelDescription: "프로젝트 의존성 설정, 프로젝트 설정 등", hex: "5a70ff"),
        Label(id: UUID().uuidString, name: "help wanted", labelDescription: "도움을 요청합니다.", hex: "00fff2"),
        Label(id: UUID().uuidString, name: "good first issue", labelDescription: "좋은 처음 이슈", hex: "ff335f"),
        Label(id: UUID().uuidString, name: "question", labelDescription: "질문", hex: "00ff00"),
        Label(id: UUID().uuidString, name: "wontfix", labelDescription: "수정 안할거임", hex: "dcff00"),
    ]
}

extension GithubRepository {
    static let mockData: [GithubRepository] = [
        GithubRepository(id: 1, name: "LabelLab", fullName: "HoJongE/LabelLab", owner: UserInfo.hojonge, isPrivate: false, repositoryDescription: ""),
        GithubRepository(id: 2, name: "Marryting", fullName: "Woody/Marryting", owner: UserInfo.woody, isPrivate: false, repositoryDescription: ""),
        GithubRepository(id: 3, name: "Inception", fullName: "Avery/Inception", owner: UserInfo.avery, isPrivate: false, repositoryDescription: "")
    ]
}
#endif
