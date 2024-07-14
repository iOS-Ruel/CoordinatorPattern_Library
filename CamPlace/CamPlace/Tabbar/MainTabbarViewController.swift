//
//  MainTabbarViewController.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/15/24.
//

import UIKit

class MainTabbarViewController: UITabBarController {
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpTabbar()
//        coordinator?.setupTabbarController()
    }
    
    
    private func setUpTabbar() {
        let firstViewController = MainMapViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        
        let secondViewController = LocationFavoriteViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "star"), tag: 1)
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        secondViewController.navigationItem.title = "즐겨찾기"
        
        tabBar.backgroundColor = .white
        
        self.viewControllers = [firstViewController, secondNavigationController]
    }
}

//#Preview {
//    UINavigationController(rootViewController: MainTabbarViewController())
//}
