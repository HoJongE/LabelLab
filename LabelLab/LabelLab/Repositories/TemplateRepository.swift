//
//  TemplateRepository.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/16.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol TemplateRepository {
    func requestTemplates(exclude userId: String?, query templateQuery: TemplateQuery) async throws -> ([Template], Bool)
    #if DEBUG
    func addTemplates(templates: [Template]) async throws
    #endif
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
        self.nameQuery = nameQuery?.uppercased()
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
    private var lastSnapshot: DocumentSnapshot?
    private var lastQuery: TemplateQuery?
    private var canUpdateMore: Bool = true

    private var collection: String {
        ProcessInfo().isRunningTests ? "TestTemplates": "Templates"
    }

    private init() { }
}

extension FirebaseTemplateRepository: TemplateRepository {
    func requestTemplates(exclude userId: String?, query templateQuery: TemplateQuery) async throws -> ([Template], Bool) {
        // 만약 이전 쿼리와 다르면, canUpdateMore 을 true로 옮긴다...
        if !checkQueryIsSame(templateQuery) {
            canUpdateMore = true
        }

        guard canUpdateMore else { return ([], false) }
        let query: Query = makeQuery(templateQuery, exclude: userId)

        do {
            let querySnapshot = try await query.getDocuments()
            var ret: [Template] = []
            for document in querySnapshot.documents {
                let template: Template = try document.data(as: Template.self)
                ret.append(template)
            }
            lastQuery = templateQuery
            lastSnapshot = querySnapshot.documents.last
            updateCanUpdateMore(query: templateQuery, count: querySnapshot.documents.count)
            return (ret, canUpdateMore)
        } catch {
            canUpdateMore = true
            lastQuery = nil
            lastSnapshot = nil
            throw error
        }
    }
}

// MARK: - For Debug & Tests
#if DEBUG
extension FirebaseTemplateRepository {
    func addTemplates(templates: [Template]) async throws {
        let writeBatch: WriteBatch = db.batch()
        for template in templates {
            let ref = db.collection(collection).document(template.id)
            writeBatch.setData(try template.encode(), forDocument: ref)
        }
        try await writeBatch.commit()
    }
}

#endif

private extension FirebaseTemplateRepository {

    func checkQueryIsSame(_ templateQuery: TemplateQuery) -> Bool {
        templateQuery == lastQuery
    }

    func updateCanUpdateMore(query: TemplateQuery, count: Int) {
        if count == 0 || count < query.perPage {
            canUpdateMore = false
        }
    }
    // TemplateQuery 를 보고 적절한 쿼리문을 만드는 함수
    func makeQuery(_ templateQuery: TemplateQuery, exclude userId: String?) -> Query {

        // 공개된 템플릿만 불러오고, copyCount 에 따라 정렬해서 불러옴
        var query = db.collection(collection)
            .whereField("makerId", isNotEqualTo: userId ?? "")
            .whereField("isOpen", isEqualTo: true)
            .order(by: "makerId", descending: true)
            .order(by: "copyCount", descending: templateQuery.descending)

        // 만약 검색 쿼리가 존재하면, name 검색 쿼리를 추가함
        if let nameQuery = templateQuery.nameQuery {
            query = query.whereField("name", isGreaterThanOrEqualTo: nameQuery)
                .whereField("name", isLessThanOrEqualTo: nameQuery + "\u{f8ff}")
        }

        // 페이지네이션을 위한 쿼리 추가
        query = query.limit(to: templateQuery.perPage)
        // 만약 쿼리가 이전 쿼리와 같으면?
        if checkQueryIsSame(templateQuery), let lastSnapshot {
            query = query.start(afterDocument: lastSnapshot)
        }

        return query
    }
}
