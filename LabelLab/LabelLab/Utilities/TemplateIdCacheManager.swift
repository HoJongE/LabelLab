//
//  TemplateIdCacheManager.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/15.
//

import Foundation

actor TemplateIdCacheManager {

    static let shared: TemplateIdCacheManager = .init()
    private var cache: Set<String> = []

    private init() { }

    func checkIdExistence(_ templateId: String) -> Bool {
        cache.contains(templateId)
    }

    func insertId(_ templateId: String) {
        cache.insert(templateId)
    }
}
