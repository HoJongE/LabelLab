//
//  LabelListInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/11.
//

import SwiftUI

protocol LabelListInteractor {
    func requestLabels(of template: Template, to labels: LoadableSubject<[Label]>) async
    func addLabel(to template: Template, _ label: Label, subject: LoadableSubject<[Label]>, event: EventSubject) async
    func modifyLabel(of template: Template, _ label: Label, subject: LoadableSubject<[Label]>, event: EventSubject) async
    func deleteLabel(of template: Template, _ label: Label, subject: LoadableSubject<[Label]>, event: EventSubject) async
}

struct RealLabelListInteractor {
    private let templateRepository: MyTemplateRepository
    private let labelRepository: LabelRepository
    private let appState: AppState

    init(templateRepository: MyTemplateRepository = FirebaseMyTemplateRepository.shared,
         labelRepository: LabelRepository = FirebaseLabelRepository.shared,
         appState: AppState) {
        self.templateRepository = templateRepository
        self.labelRepository = labelRepository
        self.appState = appState
    }
}

extension RealLabelListInteractor: LabelListInteractor {

    @MainActor func requestLabels(of template: Template, to subject: LoadableSubject<[Label]>) async {
        do {
            subject.wrappedValue = .isLoading(last: nil)
            let labels: [Label] = try await labelRepository.requestLabels(of: template)
            subject.wrappedValue = .loaded(labels)
        } catch {
            subject.wrappedValue = .failed(error)
        }
    }

    @MainActor func addLabel(to template: Template, _ label: Label, subject: LoadableSubject<[Label]>, event: EventSubject) async {
        do {
            event.wrappedValue = .notRequested
            event.wrappedValue = .isLoading(last: nil)
            try await labelRepository.addLabel(to: template, label: label)
            var appendedLabels: [Label]? = subject.wrappedValue.value
            appendedLabels?.append(label)
            event.wrappedValue = .notRequested
            guard let appendedLabels = appendedLabels else { return }
            withAnimation {
                subject.wrappedValue = .loaded(appendedLabels)
            }
        } catch {
            event.wrappedValue = .failed(error)
        }
    }

    @MainActor func modifyLabel(of template: Template, _ label: Label, subject: LoadableSubject<[Label]>, event: EventSubject) async {
        do {
            event.wrappedValue = .isLoading(last: nil)
            try await labelRepository.modifyLabel(to: template, label: label)
            var modifiedLabels: [Label]? = subject.wrappedValue.value
            modifiedLabels?.replace(to: label)
            event.wrappedValue = .notRequested
            guard let modifiedLabels = modifiedLabels else { return }
            subject.wrappedValue = .loaded(modifiedLabels)
        } catch {
            event.wrappedValue = .failed(error)
        }
    }

    @MainActor func deleteLabel(of template: Template, _ label: Label, subject: LoadableSubject<[Label]>, event: EventSubject) async {
        do {
            event.wrappedValue = .notRequested
            try await labelRepository.deleteLabel(of: template, label: label)
            var deletedLabels: [Label]? = subject.wrappedValue.value
            deletedLabels?.delete(label)
            guard let deletedLabels = deletedLabels else { return }
            withAnimation {
                subject.wrappedValue = .loaded(deletedLabels)
            }
        } catch {
            event.wrappedValue = .failed(error)
        }
    }
}
