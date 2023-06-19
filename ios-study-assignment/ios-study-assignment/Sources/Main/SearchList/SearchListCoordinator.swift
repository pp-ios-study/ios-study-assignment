//
//  SearchListCoordinator.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/06/19.
//

import UIKit

import Common
import RxSwift
import RxCocoa

final class SearchListCoordinator: BaseCoordinator {

    private let viewModel: SearchViewModelProtocol
    private let disposeBag = DisposeBag()

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
    }

    override func start() {
        let viewController = SearchDetailViewController()

        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [viewController]
    }
}
