//
//  TemplateRepository.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/23.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol MyTemplateRepository {
    func addTemplate(template: Template) async throws
    func changeTemplateVisibility(of template: Template) async throws -> Template
    func deleteTemplate(_ template: Template) async throws
    func requestTemplates(of userId: String) async throws -> [Template]
    func deleteTemplates(of userId: String) async throws
    func updateTemplateName(of template: Template, to name: String, completion: @escaping (Error?) -> Void)
    func updateTemplateDescription(of template: Template, to description: String, completion: @escaping (Error?) -> Void)
    func addTag(to template: Template, tag: String) async throws
    func deleteTag(of template: Template, tag: String) async throws
}

final class FirebaseTemplateRepository {

    static let shared: FirebaseTemplateRepository = .init()
    private let fireStore: Firestore = .firestore()
    private var collection: String {
        ProcessInfo().isRunningTests ? "TestTemplates": "Templates"
    }
    private let serialTasks: SerialTasksDispatchQueue = .init(.userInteractive)
    private let dispatchQueue: DispatchQueue = DispatchQueue(label: "Serial Queue", qos: .userInteractive)
    private let labelRepository: LabelRepository = FirebaseLabelRepository.shared

    private init() { }
}

extension FirebaseTemplateRepository: MyTemplateRepository {

    func addTemplate(template: Template) async throws {
        try await getTemplateReference(template).setData(template.encode(), merge: true)
    }

    func changeTemplateVisibility(of template: Template) async throws -> Template {
        let changeTo: Bool = !template.isOpen

        try await getTemplateReference(template)
            .updateData([
                "isOpen": changeTo
            ])

        return template.changeVisibiltiy()
    }

    func deleteTemplate(_ template: Template) async throws {
        try await labelRepository.deleteLabels(of: template)
        try await getTemplateReference(template).delete()
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
                group.addTask(priority: .userInitiated) { [self] in
                    try await labelRepository.deleteLabels(of: template)
                    try await deleteTemplate(template)
                }
            }
        })
    }

    func updateTemplateName(of template: Template, to name: String, completion: @escaping (Error?) -> Void) {
        guard !name.isEmpty else { return }
        dispatchQueue.async { [self] in
            getTemplateReference(template).updateData(["name": name], completion: completion)
        }
    }

    func updateTemplateDescription(of template: Template, to description: String, completion: @escaping (Error?) -> Void) {
        dispatchQueue.async { [self] in
            getTemplateReference(template).updateData(["templateDescription": description], completion: completion)
        }
    }

    // TODO: 태그 추가 기능 구현해야함
    func addTag(to template: Template, tag: String) async throws {
    }

    // TODO: 태그 삭제 기능 구현해야함
    func deleteTag(of template: Template, tag: String) async throws {

    }
}

private extension FirebaseTemplateRepository {
    func getTemplateReference(_ template: Template) -> DocumentReference {
        fireStore.collection(collection).document(template.id)
    }
}
