//
//  MainMapViewCoordinator.swift
//  CamPlace
//
//  Created by Chung Wussup on 7/13/24.
//

import Foundation
import UIKit

protocol MainMapDelegate: AnyObject {
    func pushDetialVC(content: LocationBasedListModel)
    func presentLocationList(contents: [LocationBasedListModel])
}


class MainMapViewCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []

    init(){
        self.navigationController = .init()
    }
    
    func start() {
        let viewModel = MainMapViewModel()
        let mapViewController = MainMapViewController(viewModel: viewModel)
        viewModel.delegate = self
        navigationController.setViewControllers([mapViewController], animated: false)
    }
    
}

extension MainMapViewCoordinator: MainMapDelegate {
    func pushDetialVC(content: LocationBasedListModel) {
        print("pushdetail")
        let detailViewModel = PlaceDetailViewModel(content: content)
        let detailCoordinator = PlaceDetailViewCoordinator(navigationController: navigationController, viewModel: detailViewModel)
        detailCoordinator.parentCoordinator = self
        childCoordinator.append(detailCoordinator)

        detailCoordinator.start()
        
    }
    
    func presentLocationList(contents: [LocationBasedListModel]) {
        print("present")
        let listViewModel = PlaceListViewModel(locationList: contents)
        let placeListCoordinator = PlaceListViewCoordinator(navigationController: navigationController, viewModel: listViewModel)
        placeListCoordinator.parentCoordinator = self
        childCoordinator.append(placeListCoordinator)

        placeListCoordinator.start()
        
    }
}
