//
//  TemplateEditingInteractor.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/08.
//

import Foundation

protocol TemplateDetailInteractor {
    func updateTemplateName(of template: Template, to name: String) async
    func updateTemplateDescription(of template: Template, to description: String) async
    func addTag(to template: Template, tag: String) async
    func deleteTag(of template: Template, tag: String) async
}

struct RealTemplateDetailInteractor {
    
}
