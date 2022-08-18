//
//  Loadable.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

enum Loadable<T> {
    case notRequested
    case isLoading(last: T?)
    case loaded(T)
    case failed(Error)

    var value: T? {
        switch self {
        case .isLoading(let last): return last
        case .loaded(let t):  return t
        default:  return nil
        }
    }

    var error: Error? {
        switch self {
        case .failed(let error):  return error
        default:  return nil
        }
    }
}

extension Loadable: CustomStringConvertible where T: CustomStringConvertible {
    var description: String {
        switch self {
        case .notRequested:
            return "\(T.self) is not requested yet"
        case .isLoading(let last):
            return "\(T.self) is Loading... last value is \(last?.description ?? "nil")"
        case .loaded(let t):
            return "Data is loaded, \(t.description)"
        case .failed(let error):
            return "Error occur when loading, error is \(error.localizedDescription)"
        }
    }
}

extension Loadable: Equatable where T: Equatable {
    static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested): return true
        case (.isLoading, .isLoading): return true
        case (.loaded, .loaded): return true
        case (.failed, .failed): return true
        default: return false
        }
    }
}
