//
//  NextViewCoordinator.swift
//  CoordinatorPattern_Sample1
//
//  Created by Chung Wussup on 7/14/24.
//

import Foundation
import UIKit

protocol NextViewCoordinatorDelegate {
    func popViewController()
}


class NextViewCoordinator: Coordinator, NextViewControllerDelegate {
 
    
    var delegate: NextViewControllerDelegate?
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let nextView = NextViewController()
        nextView.view.backgroundColor = .darkGray
        nextView.delegate = self
        self.navigationController.pushViewController(nextView, animated: true)
    }
    
    
    func popViewController() {
        self.delegate?.popViewController()
    }
}
