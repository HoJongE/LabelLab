//
//  SearchState.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/15.
//

import Foundation

final class SearchState: ObservableObject {
    @Published var searchQuery: String = ""
}
