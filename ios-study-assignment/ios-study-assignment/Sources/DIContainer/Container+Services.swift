//
//  Container+Services.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    func registerServices() {
        autoregister(SessionServiceProtocol.self, initializer: SessionService.init).inObjectScope(.container)
    }
}
