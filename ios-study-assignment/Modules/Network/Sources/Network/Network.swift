//
//  Network.swift
//
//
//  Created by 최승명 on 2023/06/07.
//

import Foundation

import Alamofire
import Domain

// MARK: - Network Service
public protocol NetworkRequestProtocol {
    associatedtype T
    func fetch() async throws -> T
}

public final class NetworkRequest<T: Decodable> {
    private let config: NetworkConfigProtocol
    private let logger: NetworkErrorLoggerProtocol
    private let session: Session = {
        let configuration = URLSessionConfiguration.default
        return Session(configuration: configuration)
    }()
    
    public init(
        config: NetworkConfigProtocol,
        logger: NetworkErrorLoggerProtocol = NetworkErrorLogger()
    ) {
        self.config = config
        self.logger = logger
    }
}

extension NetworkRequest: NetworkRequestProtocol {
    public func fetch() async throws -> T {
        
        // 1. request with Alamofire
        let afRequest = session.request(
            config.path,
            method: config.method,
            parameters: config.parameters,
            encoding: URLEncoding.default
        )
        
        // 2. response with async/await
        let response = await afRequest.serializingDecodable(T.self).response
        
        if let request = afRequest.request {
            logger.log(request: request)
        }
        
        if let error = response.error, let statusCode = response.response?.statusCode {
            let networkError = NetworkError(message: "\(error)", subMessage: .invalidRequest(statusCode))
            print(networkError.getStackTrace())
            
            throw networkError
        }
        
        // 3. JSON Decode
        if let data = response.data {
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                let error = NetworkError(message: error.localizedDescription, subMessage: .jsonDecodeError)
                print(error.getStackTrace())
                
                throw error
            }
        } else {
            let error = NetworkError(message: "\(response.error!)", subMessage: .serverError(response.response?.statusCode))
            print(error.getStackTrace())
            
            throw error
        }
    }
}

// MARK: - Network Config
public protocol NetworkConfigProtocol {
    var path: String { get }
    var parameters: [String: String] { get }
    var method: HTTPMethod { get }
}

struct NetworkConfig: NetworkConfigProtocol {
    let path: String
    let parameters: [String: String]
    let method: HTTPMethod
    
    init(
        path: String,
        parameters: [String: String] = [:],
        method: HTTPMethod = .get
    ) {
        self.path = path
        self.parameters = parameters
        self.method = method
    }
}
