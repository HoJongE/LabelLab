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
    func updateTemplateName(of template: Template, to name: String) async throws
    func updateTemplateDescription(of template: Template, to description: String) async throws
    func addTag(to template: Template, tag: String) async throws
    func deleteTag(of template: Template, tag: String) async throws
}

final class FirebaseTemplateRepository {

    static let shared: FirebaseTemplateRepository = .init()
    private let fireStore: Firestore
    private var collection: String {
        ProcessInfo().isRunningTests ? "TestTemplates": "Templates"
    }
    private let serialTasks: SerialTasks<Void> = .init()
    private let dispatchSemaphore: DispatchSemaphore = .init(value: 1)

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

        return template.changeVisibiltiy()
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

    func updateTemplateName(of template: Template, to name: String) async throws {
        guard !name.isEmpty else { return }
        await serialTasks.add { [self] in
            try await fireStore.collection(collection)
                .document(template.id)
                .updateData([
                    "name": name
                ])
        }
    }

    func updateTemplateDescription(of template: Template, to description: String) async throws {
        guard !description.isEmpty else { return }
        await serialTasks.add { [self] in
            try await fireStore.collection(collection)
                .document(template.id)
                .updateData([
                    "templateDescription": description
                ])
        }
    }

    // TODO: 태그 추가 기능 구현해야함
    func addTag(to template: Template, tag: String) async throws {
        await serialTasks.add {
        }
    }

    // TODO: 태그 삭제 기능 구현해야함
    func deleteTag(of template: Template, tag: String) async throws {
        await serialTasks.add {

        }
    }

}
