//
//  Container+ViewModels.swift
//  ios-study-assignment
//
//  Created by 최승명 on 2023/05/27.
//

import Swinject
import SwinjectAutoregistration

extension Container {
    func registerViewModels() {
        autoregister(LaunchViewModelProtocol.self, initializer: LaunchViewModel.init)
    }
}
