//
//  LabelListInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/11.
//

import Foundation

protocol LabelListInteractor {
    func requestLabels(of template: Template, to labels: LoadableSubject<[Label]>) async
    func addLabel(to template: Template, _ label: Label, labels: LoadableSubject<[Label]>) async
    func modifyLabel(of template: Template, _ label: Label, labels: LoadableSubject<[Label]>) async
    func deleteLabel(of template: Template, _ label: Label, labels: LoadableSubject<[Label]>) async
}

struct RealLabelListInteractor {
    private let templateRepository: TemplateRepository
    private let labelRepository: LabelRepository
    private let appState: AppState

    init(templateRepository: TemplateRepository = FirebaseTemplateRepository.shared,
         labelRepository: LabelRepository = FirebaseLabelRepository.shared,
         appState: AppState) {
        self.templateRepository = templateRepository
        self.labelRepository = labelRepository
        self.appState = appState
    }
}

extension RealLabelListInteractor: LabelListInteractor {

    func requestLabels(of template: Template, to subject: LoadableSubject<[Label]>) async {
        do {
            subject.wrappedValue = .isLoading(last: nil)
            let labels: [Label] = try await labelRepository.requestLabels(of: template)
            subject.wrappedValue = .loaded(labels)
        } catch {
            subject.wrappedValue = .failed(error)
        }
    }

    func addLabel(to template: Template, _ label: Label, labels: LoadableSubject<[Label]>) async {
        do {
            try await labelRepository.addLabel(to: template, label: label)
            var appendedLabels: [Label]? = labels.wrappedValue.value
            appendedLabels?.append(label)
            guard let appendedLabels else { return }
            labels.wrappedValue = .loaded(appendedLabels)
        } catch {
            print(error.localizedDescription)
        }
    }

    func modifyLabel(of template: Template, _ label: Label, labels: LoadableSubject<[Label]>) async {
        do {
            try await labelRepository.modifyLabel(to: template, label: label)
            var modifiedLabels: [Label]? = labels.wrappedValue.value
            modifiedLabels?.replace(to: label)
            guard let modifiedLabels else { return }
            labels.wrappedValue = .loaded(modifiedLabels)
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteLabel(of template: Template, _ label: Label, labels: LoadableSubject<[Label]>) async {
        do {
            try await labelRepository.deleteLabel(of: template, label: label)
            var deletedLabels: [Label]? = labels.wrappedValue.value
            deletedLabels?.delete(label)
            guard let deletedLabels else { return }
            labels.wrappedValue = .loaded(deletedLabels)
        } catch {
            print(error.localizedDescription)
        }
    }
}
