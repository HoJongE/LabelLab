//
//  InspirationInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/18.
//

protocol InspirationInteractor {
    func requestNextTemplates(query: TemplateQuery, exclude: String?, _ templates: LoadableSubject<[Template]>) async
    func copyTemplate(template: Template, isCopying: EventSubject) async
}

final class RealInspirationInteractor: InspirationInteractor {
    private let appState: AppState
    private let templateRepository: TemplateRepository
    private var lastQuery: TemplateQuery?

    init(appState: AppState,
         templateRepository: TemplateRepository = FirebaseTemplateRepository.shared) {
        self.appState = appState
        self.templateRepository = templateRepository
    }

    func requestNextTemplates(query: TemplateQuery, exclude: String? = nil, _ templates: LoadableSubject<[Template]>) async {
        do {
            defer { self.lastQuery = query }
            templates.wrappedValue = .isLoading(last: templates.wrappedValue.value)
            let templatesToAppend: [Template] = try await templateRepository.requestTemplates(exclude: exclude, query: query)

            // 만약 마지막 쿼리가 이전 쿼리와 같다면, append 해야함
            if lastQuery == query {
                guard var templatesToReplace = templates.wrappedValue.value else {
                    templates.wrappedValue = .failed(OAuthError.dataNotExist)
                    return
                }
                templatesToReplace.append(contentsOf: templatesToAppend)
                templates.wrappedValue = .loaded(templatesToReplace)
                return
            }
            // 이전 쿼리와 현재 쿼리와 다르면, 배열을 새로 셋팅해야함
            templates.wrappedValue = .loaded(templatesToAppend)
        } catch {
            templates.wrappedValue = .failed(error)
        }
    }

    // TODO: Copy 기능 구현해야함
    func copyTemplate(template: Template, isCopying: EventSubject) async {
        do {

        } catch {

        }
    }
}

