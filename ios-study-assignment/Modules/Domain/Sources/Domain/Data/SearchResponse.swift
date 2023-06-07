//
//  SearchResponse.swift
//  
//
//  Created by 최승명 on 2023/06/06.
//

import Foundation

public struct SearchResponse: Codable {
    public let resultCount: Int?
    public let results: [Search]?
}

public struct Search: Codable, Hashable {
    /// 스크린샷
    public let screenshotUrls: [String]?
    /// 사이즈별 아트워크
    public let artworkUrl60, artworkUrl100, artworkUrl512: String?
    /// 개발 앱 리스트 url
    public let artistViewURL: String?
    /// 지원 기기 종류
    public let supportedDevices: [String]?
    /// 검색어 종류
    public let kind: String?
    /// 입 이용 가능 연령
    public let contentAdvisoryRating: String?
    /// 개발자 이름
    public let sellerName: String?
    /// 릴리즈 노트
    public let releaseNotes: String?
    /// 앱 상세 뷰 url
    public let trackViewURL: String?
    /// 개발자 ID
    public let artistID: Int?
    /// 개발자명
    public let artistName: String?
    /// 장르
    public let genres: [String]?
    /// 가격
    public let price: Int?
    /// 앱 설명
    public let description: String?
    /// 앱 ID
    public let trackID: Int?
    /// 앱 이름
    public let trackName: String?
    /// 앱 순위
    public let trackContentRating: String?
    /// 장르 ID 배열
    public let genreIDS: [String]?
    /// 번들 ID
    public let bundleID: String?
    /// 앱 최소 지원 버전
    public let minimumOSVersion: String?
    /// 언어 지원 코드
    public let languageCodesISO2A: [String]?
    /// 앱 사이즈
    public let fileSizeBytes: String?
    /// 개발자 홈페이지 주소
    public let sellerURL: String?
    /// 평균 사용자 점수
    public let averageUserRating: Double?
    /// 앱 버전
    public let version: String?
    /// 사용자 리뷰 수
    public let userRatingCount: Int?

    enum CodingKeys: String, CodingKey {
        case screenshotUrls
        case artworkUrl60, artworkUrl100, artworkUrl512
        case artistViewURL = "artistViewUrl"
        case supportedDevices
        case kind
        case contentAdvisoryRating
        case sellerName
        case releaseNotes
        case trackViewURL = "trackViewUrl"
        case artistID = "artistId"
        case artistName, genres, price, description
        case trackID = "trackId"
        case trackName
        case trackContentRating
        case genreIDS = "genreIds"
        case bundleID = "bundleId"
        case minimumOSVersion = "minimumOsVersion"
        case languageCodesISO2A
        case fileSizeBytes
        case sellerURL = "sellerUrl"
        case averageUserRating
        case version
        case userRatingCount
    }
}
