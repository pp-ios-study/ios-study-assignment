//
//  LaunchViewModel.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/06.
//

import RxSwift
import RxCocoa

protocol LaunchViewModelInput {
    var sessionService: SessionServiceProtocol { get }
    var disposeBag: DisposeBag { get }
}

protocol LaunchViewModelOutput {
    func fetch()
}

protocol LaunchViewModelProtocol: LaunchViewModelInput { }

extension LaunchViewModelProtocol {
    func fetch() {
        sessionService.moveToMainSession()
    }
}

final class LaunchViewModel: LaunchViewModelProtocol {
    
    // MARK: - Input
    let sessionService: SessionServiceProtocol
    let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    init(sessionService: SessionServiceProtocol) {
        self.sessionService = sessionService
    }
}
