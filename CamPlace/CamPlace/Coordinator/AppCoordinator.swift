//
//  AppCoordinator.swift
//  CamPlace
//
//  Created by Chung Wussup on 7/13/24.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    let window: UIWindow?
    
    init(_ window: UIWindow) {
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    func start() {
        self.window?.rootViewController = setupTabbarController()
    }
    
    
    func setupTabbarController() -> UITabBarController {
        
        let tabbarController = MainTabbarViewController()
        
        let firstItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        let secondItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), tag: 1)
        
        let firstViewCoordinator = MainMapViewCoordinator()
        firstViewCoordinator.parentCoordinator = self
        childCoordinator.append(firstViewCoordinator)
        
        let mainMapVC = firstViewCoordinator.startPush()
        mainMapVC.tabBarItem = firstItem
        
        
        
        let secondViewCoordinator = LocationFavoriteCoordinator()
        secondViewCoordinator.parentCoordinator = self
        childCoordinator.append(secondViewCoordinator)
        
        let locationFavoritVC = secondViewCoordinator.startPush()
        locationFavoritVC.tabBarItem = secondItem
        
        tabbarController.viewControllers = [mainMapVC, locationFavoritVC]
        
        return tabbarController
    }
}
