//
//  LoginViewCoordinator.swift
//  CoordinatorPattern_Sample1
//
//  Created by Chung Wussup on 7/14/24.
//

import Foundation
import UIKit

protocol LoginCoordinatorDelegate { // ✅
    func didLoggedIn(_ coordinator: Coordinator)
}

class LoginCoordinator: Coordinator, LoginViewControllerDelegate {
    
    var childCoordinators: [Coordinator] = []
    var delegate: LoginCoordinatorDelegate?
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = LoginViewController()
        viewController.delegate = self
        viewController.view?.backgroundColor = .red
        self.navigationController.viewControllers = [viewController]
        
    }
    
    //MARK: - LoginViewControllerDelegate
    func login() { // ✅
        self.delegate?.didLoggedIn(self)
    }
}
