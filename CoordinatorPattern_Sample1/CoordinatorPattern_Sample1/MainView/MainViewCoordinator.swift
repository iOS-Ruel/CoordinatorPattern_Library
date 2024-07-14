//
//  MainViewCoordinator.swift
//  CoordinatorPattern_Sample1
//
//  Created by Chung Wussup on 7/14/24.
//

import Foundation
import UIKit

protocol MainCoordinatorDelegate {
    func didLoggedOut(_ coordinator: MainCoordinator)
    func didPushButton(_ coordinator: MainCoordinator)
}


class MainCoordinator: Coordinator, MainViewControllerDelegate {
    
    
    var childCoordinators: [Coordinator] = []
    var delegate: MainCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = MainViewController()
        viewController.view.backgroundColor = .cyan
        viewController.delegate = self
        self.navigationController.viewControllers = [viewController]
    }
    
    func logout() {
        self.delegate?.didLoggedOut(self)
    }
    
    func pushNextView() {
        self.delegate?.didPushButton(self)
    }
}
