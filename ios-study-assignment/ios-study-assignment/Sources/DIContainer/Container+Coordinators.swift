//
//  Container+Coordinators.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    func registerCoordinators() {
        autoregister(LaunchCoordinator.self, initializer: LaunchCoordinator.init)
        autoregister(SearchCoordinator.self, initializer: SearchCoordinator.init)
    }
}
