//
//  TemplateRepository.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/16.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol TemplateRepository {
}

final class FirebaseTemplateRepository {

    static let shared: TemplateRepository = FirebaseTemplateRepository()
    private let db: Firestore = .firestore()
    private let labelRepository: LabelRepository = FirebaseLabelRepository.shared

    private var collection: String {
        ProcessInfo().isRunningTests ? "TestTemplates": "Templates"
    }
    private init() {

    }
}




