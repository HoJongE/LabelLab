//
//  ForEachWithIndex.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/16.
//

import SwiftUI

struct ForEachWithIndex<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {

    private let data: Data
    private let content: (Int, Data.Element) -> Content

    init(_ data: Data,
         content: @escaping (Int, Data.Element) -> Content) {
        self.data = data
        self.content = content
    }

    var body: some View {
        ForEach(Array(data.enumerated()), id: \.element.id, content: content)
    }

}
