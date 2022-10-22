//
//  LabelRepository.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/09.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

enum LabelError: Error {
    case nameIsEmpty
    case nameIsAlreadyExist
}

extension LabelError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nameIsEmpty:
            return "The name of the label should not be empty"
        case .nameIsAlreadyExist:
            return "Name is alreay exist"
        }
    }
}

protocol LabelRepository {
    func requestLabels(of template: Template) async throws -> [Label]
    func addLabel(to template: Template, label: Label) async throws
    func addLabels(to template: Template, labels: [Label]) async throws
    func modifyLabel(to template: Template, label: Label) async throws
    func deleteLabel(of template: Template, label: Label) async throws
    func deleteLabels(of template: Template) async throws
}

final class FirebaseLabelRepository {

    static let shared: LabelRepository = FirebaseLabelRepository()
    private let db: Firestore = Firestore.firestore()
    private let cache: TemplateIdCacheManager = .shared
    private var collection: String {
        ProcessInfo().isRunningTests ? "TestLabels": "Labels"
    }
    private var templateCollection: String {
        ProcessInfo().isRunningTests ? "TestTemplates": "Templates"
    }

    private init() { }
}

extension FirebaseLabelRepository: LabelRepository {

    func requestLabels(of template: Template) async throws -> [Label] {
        let isCacheEnable: Bool = await cache.checkIdExistence(template.id)
        let snapshot = try await getLabelCollectionRef(of: template).getDocuments(source: isCacheEnable ? .cache: .server)
        let labels: [Label] = try snapshot.documents.map { try $0.data(as: Label.self) }
        if !isCacheEnable {
            await cache.insertId(template.id)
        }
        return labels
    }

    func addLabel(to template: Template, label: Label) async throws {
        guard !label.name.isEmpty else {
            throw LabelError.nameIsEmpty
        }

        guard try await checkNameIsNotExist(of: template, label: label) else {
            throw LabelError.nameIsAlreadyExist
        }
        try await getLabelRef(of: template, of: label).setData(label.encode())
    }

    func addLabels(to template: Template, labels: [Label]) async throws {
        try await withThrowingTaskGroup(of: Void.self, body: { group in
            for label in labels {
                group.addTask(priority: .userInitiated) {
                    try await self.getLabelRef(of: template, of: label).setData(label.encode())
                }
            }
            try await group.waitForAll()
        })
    }

    func modifyLabel(to template: Template, label: Label) async throws {
        guard !label.name.isEmpty else {
            throw LabelError.nameIsEmpty
        }
        guard try await checkNameIsNotExist(of: template, label: label) else {
            throw LabelError.nameIsAlreadyExist
        }
        try await getLabelRef(of: template, of: label).setData(label.encode())
    }

    func deleteLabel(of template: Template, label: Label) async throws {
        try await getLabelRef(of: template, of: label).delete()
    }

    func deleteLabels(of template: Template) async throws {
        let labels: [Label] = try await requestLabels(of: template)

        await withThrowingTaskGroup(of: Void.self, body: { group in
            for label in labels {
                group.addTask(priority: .userInitiated) {
                    try await self.deleteLabel(of: template, label: label)
                }
            }
        })
    }
}

private extension FirebaseLabelRepository {
    func getLabelCollectionRef(of template: Template) -> CollectionReference {
        db.collection(templateCollection).document(template.id)
            .collection(collection)
    }

    func getLabelRef(of template: Template, of label: Label) -> DocumentReference {
        db.collection(templateCollection)
            .document(template.id)
            .collection(collection)
            .document(label.id)
    }

    func checkNameIsNotExist(of template: Template, label: Label) async throws -> Bool {
        let querySnapshot = try await getLabelCollectionRef(of: template)
            .whereField("name", isEqualTo: label.name)
            .getDocuments()

        return querySnapshot.count == 0
    }
}
