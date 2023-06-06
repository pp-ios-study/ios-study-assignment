//
//  SearchViewModel.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/06.
//

import RxSwift
import RxCocoa

protocol SearchViewModelInput {
    var disposeBag: DisposeBag { get }
}

protocol SearchViewModelOutput {
    
}

protocol SearchViewModelProtocol: SearchViewModelInput & SearchViewModelOutput { }

final class SearchViewModel: SearchViewModelProtocol {
    
    // MARK: - Input
    let disposeBag: DisposeBag = DisposeBag()
    
    init() { }
}
