//
//  SearchViewModel.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/06.
//

import Foundation

import Domain
import RxSwift
import RxCocoa

protocol SearchViewModelInput {
    var disposeBag: DisposeBag { get }
    var text: PublishSubject<String> { get }
    var searchButtonClicked: PublishSubject<ControlEvent<Void>.Element> { get }
    var cancelButtonClicked: PublishSubject<ControlEvent<Void>.Element> { get }
}

protocol SearchViewModelOutput {
    var historyList: PublishRelay<[SearchHistory]> { get }
    
    func getSearchHistory()
    func saveKeyword(keyword: String)
    func deleteKeyword(keyword: String)
}

protocol SearchViewModelProtocol: SearchViewModelInput & SearchViewModelOutput { }

final class SearchViewModel: SearchViewModelProtocol {
    
    // MARK: - Input
    let disposeBag: DisposeBag = DisposeBag()
    let realm: RealmDAO<SearchHistory>
    
    let text = PublishSubject<String>()
    let searchButtonClicked = PublishSubject<ControlEvent<Void>.Element>()
    let cancelButtonClicked = PublishSubject<ControlEvent<Void>.Element>()
    
    // MARK: - Output
    let historyList = PublishRelay<[SearchHistory]>()
    
    init(realm: RealmDAO<SearchHistory>) {
        self.realm = realm
    }
}

// MARK: - Realm
extension SearchViewModel {
    func getSearchHistory() {
        let historyInfo = realm.read().sorted(by: >)
        
        historyList.accept(historyInfo)
    }
    
    func saveKeyword(keyword: String) {
        realm.write(
            value: SearchHistory(id: keyword, date: Date()),
            key: keyword
        )
    }
    
    func deleteKeyword(keyword: String) {
        realm.delete(key: keyword)
        
        getSearchHistory()
    }
}
