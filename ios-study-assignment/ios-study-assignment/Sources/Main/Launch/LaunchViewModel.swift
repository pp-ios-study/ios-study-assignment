//
//  LaunchViewModel.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/06.
//

import RxSwift
import RxCocoa

protocol LaunchViewModelInput {
    var disposeBag: DisposeBag { get }
    var sessionService: SessionServiceProtocol { get }
    var viewWillAppear: PublishRelay<Bool> { get }
}

protocol LaunchViewModelOutput { }

protocol LaunchViewModelProtocol: LaunchViewModelInput & LaunchViewModelOutput { }

final class LaunchViewModel: LaunchViewModelProtocol {
    
    // MARK: - Input
    let disposeBag: DisposeBag = DisposeBag()
    let sessionService: SessionServiceProtocol
    let viewWillAppear = PublishRelay<Bool>()
    
    // MARK: - Init
    init(sessionService: SessionServiceProtocol) {
        self.sessionService = sessionService
    }
}

// MARK: - Binding
extension LaunchViewModel {
    func bind() {
        viewWillAppear
            .subscribe(onNext: { _ in
                self.sessionService.moveToMainSession()
            })
            .disposed(by: disposeBag)
    }
}
