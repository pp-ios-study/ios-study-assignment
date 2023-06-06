//
//  RealmDAO.swift
//  
//
//  Created by 최승명 on 2023/06/06.
//

import Foundation

import RealmSwift

public protocol RealmEntity {
    associatedtype ENTITY
    
    func mapping(entity: ENTITY)
    func getEntity() -> ENTITY
}

public protocol RealmEntityMapper {
    associatedtype REALM_ENTITY
    
    func getRealmEntity() -> REALM_ENTITY
}

public class RealmDAO<VALUE: RealmEntityMapper> where VALUE.REALM_ENTITY: Object, VALUE.REALM_ENTITY: RealmEntity {
    /// KEY 타입 설정
    public typealias KEY = String
    /// 검색 기록을 관리할 realm 인스턴스
    public var realm: Realm!
    
    /// realm 초기화
    public init() {
        guard let realm = try? Realm(configuration: getRealmConfig()) else {
            print(RealmError.realmInitError.localizedDescription)
            return
        }
        self.realm = realm
    }
    
    /// realm 정보 반환
    /// - returns: Realm.Configuration
    public func getRealmConfig() -> Realm.Configuration {
        return Realm.Configuration()
    }
    
    /// realm에 값 저장
    /// - parameter value: 저장할 값
    /// - parameter key: 이미 저장된 값인지 판단하기 위한 고유 id
    public func write(value: VALUE, key: KEY) {
        do {
            try realm.write {
                if let _: VALUE.REALM_ENTITY = realm.object(
                    ofType: VALUE.REALM_ENTITY.self,
                    forPrimaryKey: key
                ) {
                    print(RealmError.realmExistError.localizedDescription)
                } else {
                    realm.add(value.getRealmEntity())
                }
            }
        } catch {
            print(RealmError.realmWriteError.localizedDescription)
        }
    }
    
    /// realm에서 읽은 데이터를 변환해서 리턴
    /// - returns: VALUE 배열
    public func read() -> [VALUE] {
        let values: [VALUE.REALM_ENTITY] = readEntity()
        
        var result = [VALUE]()
        for value in values {
            if let temp = value.getEntity() as? VALUE  {
                result.append(temp)
            }
        }
        return result
    }
    
    /// realm에서 데이터를 읽어서 리턴
    /// - returns: VALUE.REALM_ENTITY 배열
    private func readEntity() -> [VALUE.REALM_ENTITY] {
        return realm.objects(VALUE.REALM_ENTITY.self).map {$0}
    }
    
    /// realm에 값 제거
    /// - parameter key: 이미 저장된 값인지 판단하기 위한 고유 id
    public func delete(key: KEY) {
        do {
            try realm.write {
                if let value: VALUE.REALM_ENTITY = realm.object(
                    ofType: VALUE.REALM_ENTITY.self,
                    forPrimaryKey: key
                ) {
                    realm.delete(value)
                }
            }
        } catch {
            print(RealmError.realmDeleteError.localizedDescription)
        }
    }
}
