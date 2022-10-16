//
//  TemplateRepository.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/16.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol TemplateRepository {
    func requestTemplates(exclude userId: String?, query: TemplateQuery) async throws -> [Template]
}

struct TemplateQuery: Equatable {
    let descending: Bool // 내림차순으로 할 것인지?
    let nameQuery: String? // 검색 쿼리인지?
    let tags: [String] // 태그별로 검색하는지?
    let perPage: Int // 페이지 별로 몇 개의 다큐먼트를 불러오는지?

    init(descending: Bool = true,
         nameQuery: String? = nil,
         tags: [String] = [],
         perPage: Int = 15) {
        self.descending = descending
        self.nameQuery = nameQuery
        self.tags = tags
        self.perPage = perPage
    }

    static func == (lhs: TemplateQuery, rhs: TemplateQuery) -> Bool {
        lhs.descending == rhs.descending && lhs.nameQuery == rhs.nameQuery && lhs.tags == rhs.tags && lhs.perPage == rhs.perPage
    }
}

final class FirebaseTemplateRepository {

    static let shared: TemplateRepository = FirebaseTemplateRepository()
    private let db: Firestore = .firestore()
    private let labelRepository: LabelRepository = FirebaseLabelRepository.shared
    private var lastQuery: TemplateQuery?
    private var lastSnapshot: DocumentSnapshot?

    private var collection: String {
        ProcessInfo().isRunningTests ? "TestTemplates": "Templates"
    }

    private init() { }
}

extension FirebaseTemplateRepository: TemplateRepository {
    func requestTemplates(exclude userId: String?, query: TemplateQuery) async throws -> [Template] {
        let query: Query = makeQuery(query, exclude: userId)
        let querySnapshot = try await query.getDocuments()

        // 마지막 스냅샷을 지정해줌
        lastSnapshot = querySnapshot.documents.last

        var ret: [Template] = []
        for document in querySnapshot.documents {
            let template: Template = try document.data(as: Template.self)
            ret.append(template)
        }
        return ret
    }
}

private extension FirebaseTemplateRepository {

    func checkQueryIsSame(query: TemplateQuery) -> Bool {
        lastQuery == query
    }

    // TemplateQuery 를 보고 적절한 쿼리문을 만드는 함수
    func makeQuery(_ templateQuery: TemplateQuery, exclude userId: String?) -> Query {

        // 공개된 템플릿만 불러오고, copyCount 에 따라 정렬해서 불러옴
        var query = db.collection(collection)
            .whereField("makerId", isNotEqualTo: userId ?? "")
            .whereField("isOpen", isEqualTo: true)
            .order(by: "copyCount", descending: templateQuery.descending)

        // 만약 검색 쿼리가 존재하면, name 검색 쿼리를 추가함
        if let nameQuery = templateQuery.nameQuery {
            query = query.whereField("name", isGreaterThanOrEqualTo: nameQuery)
                .whereField("name", isLessThanOrEqualTo: nameQuery + "\u{f8ff}")
        }

        // 페이지네이션을 위한 쿼리 추가
        query = query.limit(to: templateQuery.perPage)

        // 만약 이전 쿼리와 현재 쿼리가 똑같으면, 페이지네이션을 구현한다.
        if checkQueryIsSame(query: templateQuery), let lastSnapshot {
            query = query.start(afterDocument: lastSnapshot)
        } else {
            lastSnapshot = nil
        }

        // 마지막 쿼리를 현재 들어온 쿼리로 설정함
        lastQuery = templateQuery

        return query
    }
}
