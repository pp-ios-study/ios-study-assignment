//
//  SearchDetailViewModel.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/26.
//

import Foundation

import Domain
import Network
import RxCocoa
import RxDataSources
import RxSwift

enum DetailSectionModel: SectionModelType {
    
    typealias Item = SearchItem
    
    enum SearchItem {
        case title(Search)
        case summary(Search)
        case releaseNote(Search)
        case screenshot(Search)
        case description(Search)
    }
    
    case title(items: [Item])
    case summary(items: [Item])
    case releaseNote(items: [Item])
    case screenshot(items: [Item])
    case description(items: [Item])
    
    init(original: DetailSectionModel, items: [Item]) {
        switch original {
        case .title(items: let items):
            self = .title(items: items)
        case .summary(items: let items):
            self = .summary(items: items)
        case .releaseNote(items: let items):
            self = .releaseNote(items: items)
        case .screenshot(items: let items):
            self = .screenshot(items: items)
        case .description(items: let items):
            self = .description(items: items)
        }
    }
    
    var items: [SearchItem] {
        switch self {
        case .title(items: let items):
            return items
        case .summary(items: let items):
            return items
        case .releaseNote(items: let items):
            return items
        case .screenshot(items: let items):
            return items
        case .description(items: let items):
            return items
        }
    }
}

protocol SearchDetailViewModelInput {
    var disposeBag: DisposeBag { get }
    var viewWillAppear: PublishSubject<Bool> { get }
    var viewWillDisappear: PublishSubject<Bool> { get }
}

protocol SearchDetailViewModelOutput {
    var item: PublishRelay<[DetailSectionModel]> { get }
    var isLargeTitle: PublishRelay<Bool> { get }
}

protocol SearchDetailViewModelProtocol: SearchDetailViewModelInput & SearchDetailViewModelOutput { }

final class SearchDetailViewModel: SearchDetailViewModelProtocol {
    
    // MARK: - Input
    let disposeBag: DisposeBag = DisposeBag()
    let viewWillAppear = PublishSubject<Bool>()
    let viewWillDisappear = PublishSubject<Bool>()
    
    // MARK: - Output
    let item = PublishRelay<[DetailSectionModel]>()
    let isLargeTitle = PublishRelay<Bool>()
    
    // MARK: - Private
    private let appInfo: Search
    
    init(appInfo: Search) {
        self.appInfo = appInfo
        
        bind()
    }
}

// MARK: - Fetch
extension SearchDetailViewModel {
    func fetchData() {
        item.accept([
            .title(items: [.title(appInfo)]),
            .summary(items: [.summary(appInfo)]),
            .releaseNote(items: [.releaseNote(appInfo)]),
            .screenshot(items: [.screenshot(appInfo)]),
            .description(items: [.description(appInfo)]),
        ])
    }
}

// MARK: - Binding
extension SearchDetailViewModel {
    func bind() {
        viewWillAppear
            .subscribe(onNext: { _ in
                self.isLargeTitle.accept(true)
                self.fetchData()
            })
            .disposed(by: disposeBag)
        
        viewWillDisappear
            .subscribe(onNext: { _ in
                self.isLargeTitle.accept(false)
            })
            .disposed(by: disposeBag)
    }
}
