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

class LaunchCoordinator: BaseCoordinator {

    private let disposeBag = DisposeBag()

    override init() { }

    override func start() {
        let viewController = LaunchViewController()

        navigationController.isNavigationBarHidden = true
        navigationController.viewControllers = [viewController]
    }
}
