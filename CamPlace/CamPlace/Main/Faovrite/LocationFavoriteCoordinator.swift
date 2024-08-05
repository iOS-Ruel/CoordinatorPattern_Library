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
        let viewModel = LocationFavoriteViewModel()
        let locationFavoriteVC = LocationFavoriteViewController(viewModel: viewModel)
        viewModel.delegate = self
        
        navigationController.setViewControllers([locationFavoriteVC], animated: false)
    }
}

extension LocationFavoriteCoordinator: LocationFavoriteDelegate {
    func pushDetialVC(content: LocationBasedListModel) {
        let detailViewModel = PlaceDetailViewModel(content: content)
        let detailCoordinator = PlaceDetailViewCoordinator(navigationController: navigationController, viewModel: detailViewModel)
        detailCoordinator.parentCoordinator = self
        childCoordinator.append(detailCoordinator)
        detailCoordinator.start()
        
    }
}
