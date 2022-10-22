//
//  Template.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

import Foundation

/// 라벨 목록을 가지고 있는 템플릿
struct Template: Codable, Identifiable {
    let id: String // 템플릿 id
    let name: String // 템플릿 이름
    let templateDescription: String // 템플릿 설명
    let makerId: String // 제작자 id
    let copyCount: Int // 복사 횟수
    let tag: [String] // tag 리스트
    let isOpen: Bool // 공개 여부
}

extension Template {
    func changeVisibiltiy() -> Template {
        Template(id: id, name: name, templateDescription: templateDescription, makerId: makerId, copyCount: copyCount, tag: tag, isOpen: !isOpen)
    }

    func changeName(to name: String) -> Template {
        Template(id: id, name: name, templateDescription: templateDescription, makerId: makerId, copyCount: copyCount, tag: tag, isOpen: isOpen)
    }

    func changeDescription(to description: String) -> Template {
        Template(id: id, name: name, templateDescription: description, makerId: makerId, copyCount: copyCount, tag: tag, isOpen: isOpen)
    }

    func copyTemplate(to userId: String) -> Template {
        Template(id: UUID().uuidString, name: name + " copied", templateDescription: templateDescription, makerId: userId, copyCount: 0, tag: tag, isOpen: false)
    }
}

extension Template: Equatable {
    static func == (lhs: Template, rhs: Template) -> Bool {
        lhs.id == rhs.id
    }
}

extension Template: CustomStringConvertible {
    var description: String {
        "템플릿 이름: \(name) 설명: \(templateDescription) 복사 횟수: \(copyCount) 공개 여부: \(isOpen)"
    }
}
