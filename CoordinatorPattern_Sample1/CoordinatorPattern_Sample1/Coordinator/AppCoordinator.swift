//
//  AppCoordinator.swift
//  CoordinatorPattern_Sample1
//
//  Created by Chung Wussup on 7/14/24.
//

import Foundation
import UIKit


class AppCoordinator: Coordinator, LoginCoordinatorDelegate, MainCoordinatorDelegate, NextViewControllerDelegate {

    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController!
    
    var isLoggedIn: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if self.isLoggedIn {
            self.showMainViewController()
        } else {
            self.showLoginViewController()
        }
    }
    
    private func showMainViewController() {
        let coordinator = MainCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func didLoggedOut(_ coordinator: MainCoordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0 !== coordinator }
        self.showLoginViewController()
    }
    
    
    private func showLoginViewController() {
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func didLoggedIn(_ coordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter{ $0 !== coordinator }
        self.showMainViewController()
    }
    
    func didPushButton(_ coordinator: MainCoordinator) {
        let coordinator = NextViewCoordinator(navigationController: self.navigationController)
        coordinator.start()
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
        childCoordinators.removeLast()
    }
}
