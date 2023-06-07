//
//  SearchViewModel.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/06.
//

import Foundation

import Domain
import Network
import RxSwift
import RxCocoa

protocol SearchViewModelInput {
    var disposeBag: DisposeBag { get }
    var service: APIProtocol { get }
    var realm: RealmDAO<SearchHistory> { get }
    var text: PublishSubject<String> { get }
    var searchButtonClicked: PublishSubject<ControlEvent<Void>.Element> { get }
    var cancelButtonClicked: PublishSubject<ControlEvent<Void>.Element> { get }
}

protocol SearchViewModelOutput {
    var historyList: PublishRelay<[SearchHistory]> { get }
    var searchList: PublishRelay<[Search]> { get }
    var isLoading: PublishRelay<Bool> { get }
    var isEmpty: PublishRelay<Bool> { get }
    
    func getSearchHistory()
    func saveKeyword(keyword: String)
    func deleteKeyword(keyword: String)
}

protocol SearchViewModelProtocol: SearchViewModelInput & SearchViewModelOutput { }

final class SearchViewModel: SearchViewModelProtocol {
    
    // MARK: - Input
    let disposeBag: DisposeBag = DisposeBag()
    let realm: RealmDAO<SearchHistory>
    let service: APIProtocol
    
    let text = PublishSubject<String>()
    let searchButtonClicked = PublishSubject<ControlEvent<Void>.Element>()
    let cancelButtonClicked = PublishSubject<ControlEvent<Void>.Element>()
    
    // MARK: - Output
    let historyList = PublishRelay<[SearchHistory]>()
    let searchList = PublishRelay<[Search]>()
    let isLoading = PublishRelay<Bool>()
    let isEmpty = PublishRelay<Bool>()
    
    init(realm: RealmDAO<SearchHistory>, service: APIProtocol) {
        self.realm = realm
        self.service = service
        
        bind()
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

// MARK: - Networking
extension SearchViewModel {
    func bind() {
        searchButtonClicked
            .withLatestFrom(text)
            .subscribe(onNext: { text in
                self.isLoading.accept(true)
                
                Task {
                    let response = try await self.service.requestRequest(keyword: text).fetch()
                    
                    guard let results = response.results else { return }
                    self.searchList.accept(results)
                    self.isEmpty.accept(results.isEmpty)
                    self.isLoading.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
}
