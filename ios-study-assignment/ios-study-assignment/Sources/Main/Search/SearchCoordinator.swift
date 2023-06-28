//
//  SearchCoordinator.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import UIKit

import Common
import Domain
import RxSwift
import RxCocoa
import Swinject
import SwinjectAutoregistration

final class SearchCoordinator: BaseCoordinator {

    private let viewModel: SearchViewModelProtocol
    private let disposeBag = DisposeBag()

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
    }

    override func start() {
        let viewController = SearchViewController(viewModel: viewModel)

        navigationController.isNavigationBarHidden = false
        navigationController.viewControllers = [viewController]
        
        bind()
    }
}

extension SearchCoordinator {
    private func bind() {
        viewModel.searchItemCellDidTap
            .subscribe(onNext: { [weak self] indexPath, item in self?.showSearchDetail(appInfo: item) })
            .disposed(by: disposeBag)
    }
    
    private func showSearchDetail(appInfo: Search) {
        let viewController = SearchDetailViewController(
            viewModel: SearchDetailViewModel(appInfo: appInfo) as SearchDetailViewModelProtocol
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}
