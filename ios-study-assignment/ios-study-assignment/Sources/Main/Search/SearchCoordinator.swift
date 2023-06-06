//
//  SearchCoordinator.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import UIKit

import Common
import RxSwift
import RxCocoa

class SearchCoordinator: BaseCoordinator {

    private let viewModel: SearchViewModelProtocol
    private let disposeBag = DisposeBag()

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
    }

    override func start() {
        let viewController = SearchViewController(viewModel: viewModel)

        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [viewController]
    }
}
