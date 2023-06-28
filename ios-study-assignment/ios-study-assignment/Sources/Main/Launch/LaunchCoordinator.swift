//
//  LaunchCoordinator.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import UIKit

import Common
import RxSwift
import RxCocoa

final class LaunchCoordinator: BaseCoordinator {

    private let viewModel: LaunchViewModelProtocol
    private let disposeBag = DisposeBag()

    init(viewModel: LaunchViewModelProtocol) {
        self.viewModel = viewModel
    }

    override func start() {
        let viewController = LaunchViewController(viewModel: viewModel)

        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [viewController]
    }
}
