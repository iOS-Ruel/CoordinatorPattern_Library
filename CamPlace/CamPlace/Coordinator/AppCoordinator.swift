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
        
        let tabbarController = UITabBarController()
        
        let firstItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        let secondItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), tag: 1)
        
        let firstViewCoordinator = MainMapViewCoordinator()
        firstViewCoordinator.parentCoordinator = self
        
        firstViewCoordinator.start()
        
        let mainMapVC = firstViewCoordinator.navigationController
        mainMapVC.tabBarItem = firstItem
        mainMapVC.topViewController?.title = "지도"
        
        let secondViewCoordinator = LocationFavoriteCoordinator()
        secondViewCoordinator.parentCoordinator = self

        
        secondViewCoordinator.start()
        let locationFavoritVC = secondViewCoordinator.navigationController
        locationFavoritVC.tabBarItem = secondItem
        locationFavoritVC.topViewController?.title = "즐겨찾기"

        tabbarController.viewControllers = [mainMapVC, locationFavoritVC]
        
        return tabbarController
    }
}
