//
//  TemplateRepository.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol TemplateRepository {
    func addTemplate(template: Template) async throws
    func changeTemplateVisibility(of template: Template) async throws -> Template
    func deleteTemplate(_ template: Template) async throws
    func requestTemplates(of userId: String) async throws -> [Template]
    func deleteTemplates(of userId: String) async throws
}

final class FirebaseTemplateRepository {

    static let shared: FirebaseTemplateRepository = .init()
    private let fireStore: Firestore
    private var collection: String {
        ProcessInfo().isRunningTests ? "TestTemplates": "Templates"
    }

    init(fireStore: Firestore = .firestore()) {
        self.fireStore = fireStore
    }
}

extension FirebaseTemplateRepository: TemplateRepository {

    func addTemplate(template: Template) async throws {
        try await fireStore.collection(collection)
            .document(template.id)
            .setData(template.encode(), merge: true)
    }

    func changeTemplateVisibility(of template: Template) async throws -> Template {
        let changeTo: Bool = !template.isOpen

        try await fireStore.collection(collection)
            .document(template.id)
            .updateData([
                "isOpen": changeTo
            ])

        return Template(id: template.id, name: template.name, templateDescription: template.templateDescription, makerId: template.makerId, copyCount: template.copyCount, tag: template.tag, isOpen: changeTo)
    }

    func deleteTemplate(_ template: Template) async throws {
        try await fireStore.collection(collection)
            .document(template.id)
            .delete()
    }

    func requestTemplates(of userId: String) async throws -> [Template] {
        let querySnapshot = try await fireStore.collection(collection)
            .whereField("makerId", isEqualTo: userId)
            .getDocuments()

        var ret: [Template] = []
        for document in querySnapshot.documents {
            try ret.append(document.data(as: Template.self))
        }

        return ret
    }

    func deleteTemplates(of userId: String) async throws {
        let templates: [Template] = try await requestTemplates(of: userId)

        await withThrowingTaskGroup(of: Void.self, body: { group in
            for template in templates {
                group.addTask(priority: .userInitiated) {
                    try await self.deleteTemplate(template)
                }
            }
        })
    }

}
