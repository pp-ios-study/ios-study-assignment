//
//  BaseCoordinator.swift
//  
//
//  Created by 최승명 on 2023/05/26.
//

import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func start(coordinator: Coordinator)
    func didFinish(coordinator: Coordinator)
    func removeChildCoordinators()
}

open class BaseCoordinator: Coordinator {
    public var navigationController = UINavigationController()
    public var childCoordinators = [Coordinator]()
    public var parentCoordinator: Coordinator?
    
    public init() { }
    
    open func start() {
        fatalError("Start method should be implemented.")
    }
    
    open func start(coordinator: Coordinator) {
        childCoordinators += [coordinator]
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    open func removeChildCoordinators() {
        childCoordinators.forEach { $0.removeChildCoordinators() }
        childCoordinators.removeAll()
    }
    
    open func didFinish(coordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
