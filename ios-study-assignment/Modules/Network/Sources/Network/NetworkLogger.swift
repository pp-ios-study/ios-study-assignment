//
//  NetworkLogger.swift
//  
//
//  Created by 최승명 on 2023/06/07.
//

import Foundation

// MARK: - Logger
public protocol NetworkErrorLoggerProtocol {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
}

public final class NetworkErrorLogger: NetworkErrorLoggerProtocol {
    public init() { }

    public func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        
        if let httpBody = request.httpBody,
           let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    public func log(responseData data: Data?, response: URLResponse?) {
        if let data = data, let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        } else if let response = response {
            printIfDebug(String(describing: response.url))
            printIfDebug(response.debugDescription)
        }
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
