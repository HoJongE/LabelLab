//
//  MockLabelRepository.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/10/11.
//

@testable import LabelLab
import Foundation

final class MockLabelRepository: LabelRepository {

    private var error: Error?
    private var labels: [Label] = []

    init(_ error: Error? = nil) {
        self.error = error
    }

    func injectError(_ error: Error) {
        self.error = error
    }

    func requestLabels(of template: LabelLab.Template) async throws -> [LabelLab.Label] {
        try throwError()
        return labels
    }

    func addLabel(to template: LabelLab.Template, label: LabelLab.Label) async throws {
        try throwError()
        labels.append(label)
    }

    func modifyLabel(to template: LabelLab.Template, label: LabelLab.Label) async throws {
        try throwError()
        labels.replace(to: label)
    }

    func deleteLabel(of template: LabelLab.Template, label: LabelLab.Label) async throws {
        try throwError()
        labels.delete(label)
    }

    func deleteLabels(of template: LabelLab.Template) async throws {
        try throwError()
        labels.removeAll()
    }

}

private extension MockLabelRepository {
    func throwError() throws {
        if let error {
            throw error
        }
    }
}
