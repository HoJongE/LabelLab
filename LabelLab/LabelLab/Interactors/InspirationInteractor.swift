//
//  InspirationInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/18.
//

import Foundation

protocol InspirationInteractor {
    func requestNextTemplates(query: TemplateQuery, force reloading: Bool)
    func copyTemplate(template: Template, to userId: String, isCopying: EventSubject) async
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

    func requestNextTemplates(query: TemplateQuery, force reloading: Bool = false) {
        dispatchQueue.async {
            Task(priority: .userInitiated) { [weak self] in
                await self?.requestNextTemplates(query: query, force: reloading)
            }
        }
    }

    @MainActor func requestNextTemplates(query: TemplateQuery, force reloading: Bool = false) async {
        do {
            var query: TemplateQuery = query
            if reloading {
                canUpdateMore = true
                // 이전 쿼리의 요청 페이지 수가 10이면, 현재 쿼리 요청을 11로 변경함
                if lastQuery?.perPage == 10 {
                    query = TemplateQuery(descending: query.descending, nameQuery: query.nameQuery, tags: query.tags, perPage: 11)
                }
                // 이전 쿼리가 없거나 요청 페이지 수가 11이면, 현재 쿼리 요청을 10으로 변경함
                else {
                    query = TemplateQuery(descending: query.descending, nameQuery: query.nameQuery, tags: query.tags, perPage: 10)
                }
                lastQuery = nil
            }
            if lastQuery != query {
                canUpdateMore = true
            }
            guard canUpdateMore else { return }
            if reloading {
                appState.userData.templateList = .isLoading(last: nil)
            } else {
                appState.userData.templateList = .isLoading(last: appState.userData.templateList.value)
            }
            let exclude: Int? = appState.userData.userInfo.value?.id
            let result = try await templateRepository.requestTemplates(exclude: exclude != nil ? String(exclude!): "", query: query)
            defer {
                canUpdateMore = result.1
            }
            let templatesToAppend: [Template] = result.0
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
            canUpdateMore = true
            appState.userData.templateList = .failed(error)
        }
    }

    @MainActor func copyTemplate(template: Template, to userId: String, isCopying: EventSubject) async {
        do {
            isCopying.wrappedValue = .isLoading(last: nil)
            let copiedTemplate = try await templateRepository.copyTemplate(template, to: userId)
            var myTemplates = appState.userData.myTemplateList.value
            myTemplates?.append(copiedTemplate)
            if let myTemplates = myTemplates {
                appState.userData.myTemplateList = .loaded(myTemplates)
            }
            isCopying.wrappedValue = .loaded(true)
        } catch {
            isCopying.wrappedValue = .failed(error)
        }
    }
}
