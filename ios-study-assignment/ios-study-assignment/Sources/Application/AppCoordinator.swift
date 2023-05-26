//
//  AppCoordinator.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/26.
//

import UIKit

import Common
import RxSwift

class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    private let sessionService: SessionServiceProtocol
    private let disposeBag = DisposeBag()
    
    init(window: UIWindow, sessionService: SessionServiceProtocol) {
        self.window = window
        self.sessionService = sessionService
        
        super.init()
    }
    
    override func start() {
        showLaunch()
        
        sessionService.main
            .subscribe(onNext: { [weak self] in self?.showMain() })
            .disposed(by: disposeBag)
    }
}

extension AppCoordinator {
    private func showLaunch() {
        removeChildCoordinators()
        
        let coordinator = SceneDelegate.container.resolve(LaunchCoordinator.self)!
        start(coordinator: coordinator)
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: coordinator.navigationController,
            withAnimation: true)
    }
    
    private func showMain() {
        removeChildCoordinators()
        
        let coordinator = SceneDelegate.container.resolve(SearchCoordinator.self)!
        start(coordinator: coordinator)
        
        ViewControllerUtils.setRootViewController(
            window: window,
            viewController: coordinator.navigationController,
            withAnimation: true)
    }
}
