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
struct SearchHistory: Equatable, Identifiable {
    /// 검색 기록 텍스트
    var id: String
    /// 검색한 시간
    var date: Date
    
    static func > (lhs: SearchHistory, rhs: SearchHistory) -> Bool {
        return lhs.date > rhs.date
    }
    
    static func == (lhs: SearchHistory, rhs: SearchHistory) -> Bool {
        return lhs.id == rhs.id
    }
}

extension SearchHistory: RealmEntityMapper {
    typealias REALM_ENTITY = SearchHistoryRealmEntity
    
    /// 인스턴스를 RealmEntity로 변환해서 반환
    /// - returns: RealmEntity
    func getRealmEntity() -> REALM_ENTITY {
        let mapper = SearchHistoryRealmEntity()
        mapper.mapping(entity: self)
        return mapper
    }
}

class SearchHistoryRealmEntity: Object, RealmEntity {
    /// ENTITY 타입 설정
    typealias ENTITY = SearchHistory
    
    /// 검색 기록 텍스트 (primary key)
    @objc dynamic var id = ""
    /// 검색한 시간
    @objc dynamic var date = Date()
    
    /// id를 primary key로 설정
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /// 인스턴스를 RealmEntity로 매핑
    func mapping(entity: ENTITY) {
        id = entity.id
        date = entity.date
    }
    
    /// 인스턴스를 원래의 Entity로 변환해서 반환
    /// - returns: Entity
    func getEntity() -> ENTITY {
        return SearchHistory(
            id: id,
            date: date
        )
    }
}
