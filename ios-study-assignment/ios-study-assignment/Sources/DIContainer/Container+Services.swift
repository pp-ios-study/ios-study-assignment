//
//  Container+Services.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import Domain
import Network
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerServices() {
        autoregister(SessionServiceProtocol.self, initializer: SessionService.init).inObjectScope(.container)
        autoregister(RealmDAO<SearchHistory>.self, initializer: RealmDAO.init)
        autoregister(APIProtocol.self, initializer: API.init)
    }
}
