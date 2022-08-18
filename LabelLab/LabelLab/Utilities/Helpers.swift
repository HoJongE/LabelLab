//
//  Helpers.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

import Foundation

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}
