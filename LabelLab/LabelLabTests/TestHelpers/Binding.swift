//
//  Binding.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/09.
//

import SwiftUI

struct BindingWrapper<Value> {
    var binding: Binding<Value>

    init(value: Value) {
        var value = value
        self.binding = Binding(get: { value }, set: { value = $0 })
    }

}
