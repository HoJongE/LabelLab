//
//  LabelRepository.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/09.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

protocol LabelRepository {
    func requestLabels(of template: Template) async throws -> [Label]
    func addLabel(to template: Template, label: Label) async throws
    func modifyLabel(to template: Template, label: Label) async throws
    func deleteLabel(of template: Template, label: Label) async throws
    func deleteLabels(of template: Template) async throws
}

final class FirebaseLabelRepository {

    static let shared: LabelRepository = FirebaseLabelRepository()
    private let db: Firestore = Firestore.firestore()
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
        let snapshot = try await getLabelCollectionRef(of: template).getDocuments()

        return try snapshot.documents.map { snapshot in
            try snapshot.data(as: Label.self)
        }
    }

    func addLabel(to template: Template, label: Label) async throws {
        try await getLabelRef(of: template, of: label).setData(label.encode())
    }

    func modifyLabel(to template: Template, label: Label) async throws {
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
}
