//
//  SessionService.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import RxSwift

protocol SessionServiceProtocol {
    var main: Observable<Void> { get }
    
    func moveToMainSession()
}

class SessionService: SessionServiceProtocol {
    
    private let mainSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    var main: Observable<Void> {
        return mainSubject.asObservable()
    }
    
    init() {}
    
    func moveToMainSession() {
        mainSubject.onNext(Void())
    }
}
