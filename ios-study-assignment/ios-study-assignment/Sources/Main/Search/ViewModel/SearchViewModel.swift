//
//  SearchViewModel.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/06.
//

import Foundation

import Domain
import Network
import RxCocoa
import RxDataSources
import RxSwift

enum SectionModel: SectionModelType {
    
    typealias Item = SearchItem
    
    enum SearchItem {
        case history(String)
        case typing(String)
    }
    
    case history(items: [Item])
    case typing(items: [Item])
    
    init(original: SectionModel, items: [Item]) {
        switch original {
        case .history(items: let items):
            self = .history(items: items)
        case .typing(items: let items):
            self = .typing(items: items)
        }
    }
    
    var items: [SearchItem] {
        switch self {
        case .history(items: let items):
            return items
        case .typing(items: let items):
            return items
        }
    }
    
    var headerTitle: String? {
        switch self {
        case .history:
            return "최근 검색어"
        case .typing:
            return nil
        }
    }
}

protocol SearchViewModelInput {
    var disposeBag: DisposeBag { get }
    var service: APIProtocol { get }
    var realm: RealmDAO<SearchHistory> { get }
    var text: PublishSubject<String> { get }
    var searchButtonClicked: PublishSubject<ControlEvent<Void>.Element> { get }
    var cancelButtonClicked: PublishSubject<ControlEvent<Void>.Element> { get }
    var tableCellSelected: PublishSubject<(ControlEvent<IndexPath>.Element, ControlEvent<SectionModel.SearchItem>.Element)> { get }
}

protocol SearchViewModelOutput {
    var item: PublishRelay<[SectionModel]> { get }
    var searchList: PublishRelay<[Search]> { get }
    var title: PublishRelay<String> { get }
    var isLoading: PublishRelay<Bool> { get }
    var isEmpty: PublishRelay<Bool> { get }
    var isShowResult: PublishRelay<Bool> { get }
    
    func fetchDataBase()
    func saveKeyword(keyword: String)
    func getSearchHistory() -> [SearchHistory]
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
    let tableCellSelected = PublishSubject<(ControlEvent<IndexPath>.Element, ControlEvent<SectionModel.SearchItem>.Element)>()
    
    // MARK: - Output
    let item = PublishRelay<[SectionModel]>()
    let searchList = PublishRelay<[Search]>()
    let title = PublishRelay<String>()
    let isLoading = PublishRelay<Bool>()
    let isEmpty = PublishRelay<Bool>()
    let isShowResult = PublishRelay<Bool>()
    
    init(realm: RealmDAO<SearchHistory>, service: APIProtocol) {
        self.realm = realm
        self.service = service
        
        bind()
    }
}

// MARK: - Fetch
extension SearchViewModel {
    func fetchDataBase() {
        let searchHistory = self.getSearchHistory()
        item.accept([.history(items: searchHistory.map { .history($0.id) })])
    }
    
    func fetchSearch(keyword: String) {
        Task {
            let response = try await self.service.requestRequest(keyword: keyword).fetch()
            
            if let results = response.results {
                self.searchList.accept(results)
                self.title.accept(keyword)
                self.isEmpty.accept(results.isEmpty)
                self.isLoading.accept(false)
                self.isShowResult.accept(!results.isEmpty)
            } else {
                self.searchList.accept([])
                self.title.accept(keyword)
                self.isEmpty.accept(true)
                self.isLoading.accept(false)
                self.isShowResult.accept(true)
            }
        }
    }
}


// MARK: - Realm
extension SearchViewModel {
    func saveKeyword(keyword: String) {
        realm.write(
            value: SearchHistory(id: keyword, date: Date()),
            key: keyword
        )
    }
    
    func getSearchHistory() -> [SearchHistory] {
        let searchHistory = realm.read().sorted(by: >)
        return searchHistory
    }
    
    func deleteKeyword(keyword: String) {
        realm.delete(key: keyword)
        
        let searchHistory = self.getSearchHistory()
        item.accept([.history(items: searchHistory.map { .history($0.id) })])
    }
}

// MARK: - Search Bar
extension SearchViewModel {
    func bind() {
        text
            .subscribe(onNext: { text in
                if text.isEmpty {
                    let searchHistory = self.getSearchHistory()
                    self.item.accept([.history(items: searchHistory.map { .history($0.id) })])
                } else {
                    let searchHistory = self.getSearchHistory().filter({ $0.id.contains(text) })
                    self.item.accept([.typing(items: searchHistory.map { .typing($0.id) })])
                }
            })
            .disposed(by: disposeBag)
        
        searchButtonClicked
            .delay(.seconds(2), scheduler: MainScheduler.asyncInstance)
            .withLatestFrom(text)
            .subscribe(onNext: { text in
                self.isLoading.accept(true)
                self.saveKeyword(keyword: text)
                self.fetchSearch(keyword: text)
            })
            .disposed(by: disposeBag)
        
        cancelButtonClicked
            .subscribe(onNext: {
                self.title.accept("")
                self.isShowResult.accept(false)
            })
            .disposed(by: disposeBag)
        
        tableCellSelected
            .subscribe(onNext: { (indexPath, section) in
                switch section {
                case .history(let text):
                    self.title.accept(text)
                    self.fetchSearch(keyword: text)
                case .typing(let text):
                    self.title.accept(text)
                    self.fetchSearch(keyword: text)
                }
                
                self.isShowResult.accept(true)
            })
            .disposed(by: disposeBag)
    }
}
