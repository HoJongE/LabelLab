//
//  SerialTasks.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/10/08.
//

import Foundation

final class SerialTasksDispatchQueue {
    private let queue: DispatchQueue
    private let semaphore: DispatchSemaphore = .init(value: 1)

    init(_ qos: DispatchQoS = .userInteractive) {
        queue = DispatchQueue(label: "Serial Queue", qos: qos)
    }

    func addTask(_ block: @Sendable @escaping () async throws -> Void) {
        queue.async { [weak self] in
            guard let self else { return }
            self.semaphore.wait()
            Task(priority: .userInitiated) {
                defer { self.semaphore.signal() }
                try await block()
            }
        }
    }
}
