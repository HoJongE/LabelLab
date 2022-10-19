//
//  InspirationInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/18.
//

import Foundation

protocol InspirationInteractor {
    func requestNextTemplates(query: TemplateQuery)
    func copyTemplate(template: Template, isCopying: EventSubject) async
}

final class RealInspirationInteractor: InspirationInteractor {
    private let appState: AppState
    private let templateRepository: TemplateRepository
    private var lastQuery: TemplateQuery?
    private var canUpdateMore: Bool = true
    private let dispatchQueue: DispatchQueue = DispatchQueue(label: "Serial queue for pagianation", qos: .userInteractive)

    init(appState: AppState,
         templateRepository: TemplateRepository = FirebaseTemplateRepository.shared) {
        self.appState = appState
        self.templateRepository = templateRepository
    }

    func requestNextTemplates(query: TemplateQuery) {
        dispatchQueue.async {
            Task(priority: .userInitiated) { [weak self] in
                await self?.requestNextTemplates(query: query)
            }
        }
    }

    @MainActor func requestNextTemplates(query: TemplateQuery) async {
        do {
            if lastQuery != query {
                canUpdateMore = true
            }
            guard canUpdateMore else { return }
            appState.userData.templateList = .isLoading(last: appState.userData.templateList.value)
            let exclude: Int? = appState.userData.userInfo.value?.id
            let result = try await templateRepository.requestTemplates(exclude: exclude != nil ? String(exclude!): "", query: query)
            let templatesToAppend: [Template] = result.0

            defer {
                canUpdateMore = result.1
            }
            // 만약 마지막 쿼리가 이전 쿼리와 같다면, append 해야함
            if query == lastQuery {
                guard var templatesToReplace = appState.userData.templateList.value else {
                    appState.userData.templateList = .loaded(templatesToAppend)
                    return
                }
                templatesToReplace.append(contentsOf: templatesToAppend)
                appState.userData.templateList = .loaded(templatesToReplace)
                lastQuery = query
                return
            }
            // 이전 쿼리와 현재 쿼리와 다르면, 배열을 새로 셋팅해야함
            appState.userData.templateList = .loaded(templatesToAppend)
            lastQuery = query
        } catch {
            lastQuery = nil
            appState.userData.templateList = .failed(error)
        }
    }

    // TODO: Copy 기능 구현해야함
    @MainActor func copyTemplate(template: Template, isCopying: EventSubject) async {
        do {

        } catch {

        }
    }
}

