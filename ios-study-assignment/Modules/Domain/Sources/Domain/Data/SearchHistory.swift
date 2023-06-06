//
//  SearchHistory.swift
//  
//
//  Created by 최승명 on 2023/06/06.
//

import Foundation

import RealmSwift

let HISTORY_UPDATE_NOTIFICATION: NSNotification.Name = NSNotification.Name("HistoryUpdate")

// 검색 기록
public struct SearchHistory: Equatable, Identifiable {
    /// 검색 기록 텍스트
    public var id: String
    /// 검색한 시간
    public var date: Date
    
    public init(id: String, date: Date) {
        self.id = id
        self.date = date
    }
    
    public static func > (lhs: SearchHistory, rhs: SearchHistory) -> Bool {
        return lhs.date > rhs.date
    }
    
    public static func == (lhs: SearchHistory, rhs: SearchHistory) -> Bool {
        return lhs.id == rhs.id
    }
}

extension SearchHistory: RealmEntityMapper {
    public typealias REALM_ENTITY = SearchHistoryRealmEntity
    
    /// 인스턴스를 RealmEntity로 변환해서 반환
    /// - returns: RealmEntity
    public func getRealmEntity() -> REALM_ENTITY {
        let mapper = SearchHistoryRealmEntity()
        mapper.mapping(entity: self)
        return mapper
    }
}

public class SearchHistoryRealmEntity: Object, RealmEntity {
    /// ENTITY 타입 설정
    public typealias ENTITY = SearchHistory
    
    /// 검색 기록 텍스트 (primary key)
    @objc dynamic var id = ""
    /// 검색한 시간
    @objc dynamic var date = Date()
    
    /// id를 primary key로 설정
    public override static func primaryKey() -> String? {
        return "id"
    }
    
    /// 인스턴스를 RealmEntity로 매핑
    public func mapping(entity: ENTITY) {
        id = entity.id
        date = entity.date
    }
    
    /// 인스턴스를 원래의 Entity로 변환해서 반환
    /// - returns: Entity
    public func getEntity() -> ENTITY {
        return SearchHistory(
            id: id,
            date: date
        )
    }
}
