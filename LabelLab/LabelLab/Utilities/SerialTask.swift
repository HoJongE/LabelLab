//
//  SerialTask.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/08.
//

import Foundation

actor SerialTasks<Success> {
    private var previousTask: Task<Success, Error>?

    func add(block: @Sendable @escaping () async throws -> Success) {
        previousTask = Task { [previousTask] in
            _ = await previousTask?.result
            return try await block()
        }
    }

    deinit {
        print("Actor deinited")
    }
}
