//
//  NetworkError.swift
//  
//
//  Created by 최승명 on 2023/06/07.
//

import Foundation

// MARK: - Network Error Type
public enum NetworkErrorType {
    case none
    case invalidRequest(Int)
    case serverError(Int?)
    case jsonDecodeError
}

public protocol LocalizedErrorProtocl {
    var errorDescription: String { get }
}

extension NetworkErrorType: LocalizedErrorProtocl {
    public var errorDescription: String {
        switch self {
        case .none:
            return ""
        case .invalidRequest(let code):
            return "잘못된 리퀘스트, status code:\(code)"
        case .serverError(let code):
            return "서버 에러, status code:\(code ?? -1)"
        case .jsonDecodeError:
            return "JSON 파싱 에러"
        }
    }
}

// MARK: - Network Error
public protocol NetworkErrorProtocol {
    func getStackTrace() -> String
}

public final class NetworkError: Error {
    private let errorPlace: String
    public let message: String
    public let subMessage: NetworkErrorType
    
    public init(
        message: String,
        subMessage: NetworkErrorType = .none,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        self.message = message
        self.subMessage = subMessage
        self.errorPlace = "\(file) \(line): \(function)"
    }
}

extension NetworkError: NetworkErrorProtocol {
    public func getStackTrace() -> String {
        let error = "🔶[ERROR START]🔶 \n"
        + "✔️ place: \(errorPlace) \n"
        + "✔️ message: \(message) \n"
        + "✔️ subMessage: \(subMessage.errorDescription) \n"
        + "🔶[ERROR END]🔶"
        return error
    }
}
