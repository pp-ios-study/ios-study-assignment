//
//  API.swift
//  
//
//  Created by 최승명 on 2023/06/07.
//

import Foundation

import Domain

public protocol APIProtocol {
    func requestRequest(keyword: String) -> NetworkRequest<SearchResponse>
}

public class API: APIProtocol {
    private let baseURL: String = "https://itunes.apple.com"
    
    enum Path: String {
        case search = "/search"
    }
    
    public init() { }
    
    public func requestRequest(keyword: String) -> NetworkRequest<SearchResponse> {
        NetworkRequest<SearchResponse>(
            config: NetworkConfig(
                path: baseURL + Path.search.rawValue,
                parameters: [
                    "term": keyword,
                    "country": "KR",
                    "media": "software"
                ],
                method: .get
            )
        )
    }
}
