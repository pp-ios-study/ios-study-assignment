//
//  RealmError.swift
//  
//
//  Created by 최승명 on 2023/06/06.
//

import Foundation

enum RealmError: String, Error {
    case realmInitError = "초기화에 에러가 발생했습니다."
    case realmWriteError = "값을 저장하는데 에러가 발생했습니다."
    case realmExistError = "이미 존재하는 데이터 입니다."
    case realmReadError = "값을 읽는데 에러가 발생했습니다."
    case realmDeleteError = "값을 삭제하는데 에러가 발생했습니다."
}
