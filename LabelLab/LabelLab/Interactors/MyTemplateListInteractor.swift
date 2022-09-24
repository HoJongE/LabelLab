//
//  MyTemplateListInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/09/22.
//

protocol MyTemplateListInteractor {
    func addTemplate() async
    func changeTemplateVisibility(of template: Template) async
    func deleteTemplate(_ template: Template) async
    func loadTemplates() async
}
