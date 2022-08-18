//
//  AuthenticationRequiredLoadable.swift
//  LabelLab
//
//  Created by JongHo Park on 2022/08/18.
//

enum AuthenticationRequiredLoadable<T> {
    case notRequested
    case isLoading(last: T?)
    case loaded(T)
    case failed(Error)
    case needAuthentication

    var value: T? {
        switch self {
        case .loaded(let value):  return value
        case .isLoading(last: let value): return value
        default: return nil
        }
    }

    var error: Error? {
        switch self {
        case .failed(let error): return error
        default: return nil
        }
    }
}

extension AuthenticationRequiredLoadable: CustomStringConvertible where T: CustomStringConvertible {
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
        case .needAuthentication:
            return "Need authentication to load \(T.self)"
        }
    }
}

extension AuthenticationRequiredLoadable: Equatable where T: Equatable {
    static func == (lhs: AuthenticationRequiredLoadable<T>, rhs: AuthenticationRequiredLoadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested): return true
        case (.isLoading(let first), .isLoading(let second)) where first == second: return true
        case (.loaded(let first), .loaded(let second)) where first == second: return true
        case (.failed, .failed): return true
        case (.needAuthentication, .needAuthentication): return true
        default: return false
        }
    }
}
