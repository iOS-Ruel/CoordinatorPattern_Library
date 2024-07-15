//
//  LocationFavoriteCoordinator.swift
//  CamPlace
//
//  Created by Chung Wussup on 7/13/24.
//

import Foundation
import UIKit

class LocationFavoriteCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    var childCoordinator: [Coordinator] = []
    
    
    init(){
        self.navigationController = .init()
    }
    
    func start() {
        
    }
 
    func startPush() -> UINavigationController {
        let viewModel = LocationFavoriteViewModel()
        let locationFavoriteVC = LocationFavoriteViewController(viewModel: viewModel)
        viewModel.delegate = self
        
        navigationController.setViewControllers([locationFavoriteVC], animated: false)
        return navigationController
    }
}

extension LocationFavoriteCoordinator: LocationFavoriteDelegate {
    func pushDetialVC(content: LocationBasedListModel) {
        let viewModel = PlaceDetailViewModel(content: content)
        let vc = PlaceDetailViewController(viewModel: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
