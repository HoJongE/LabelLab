//
//  Binding.swift
//  LabelLabTests
//
//  Created by JongHo Park on 2022/09/09.
//

import SwiftUI

struct BindingWrapper<Value> {
    private var _binding: Binding<Value>

    var value: Value {
        binding.wrappedValue
    }

    var binding: Binding<Value> {
        _binding
    }

    init(value: Value) {
        var value = value
        self._binding = Binding(get: { value }, set: { value = $0 })
    }

}
