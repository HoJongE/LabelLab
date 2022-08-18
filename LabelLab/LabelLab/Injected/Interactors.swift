//
//  Interactors.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

extension DIContainer {

    struct Interactors {
        
    }

}

// MARK: - For previews
#if DEBUG
extension DIContainer.Interactors {
    static var preview: DIContainer.Interactors {
        DIContainer.Interactors()
    }
}
#endif
