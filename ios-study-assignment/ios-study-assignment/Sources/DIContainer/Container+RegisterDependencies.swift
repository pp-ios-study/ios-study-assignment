//
//  Container+RegisterDependencies.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import Swinject

extension Container {
    func registerDependencies() {
        registerCoordinators()
        registerViewModels()
        registerServices()
    }
}
