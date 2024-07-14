//
//  MainMapViewCoordinator.swift
//  CamPlace
//
//  Created by Chung Wussup on 7/13/24.
//

import Foundation
import UIKit

class MainMapViewCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    
    var childCoordinator: [Coordinator] = []
    
    
    init(){
        self.navigationController = .init()
    }
    
    func start() {
        
    }
    
 
    func startPush() -> UINavigationController {
        let mapViewController = MainMapViewController()
        mapViewController.delegate = self
        navigationController.setViewControllers([mapViewController], animated: false)
        
        return navigationController
    }
}

extension MainMapViewCoordinator: MainMapDelegate {
    func pushDetialVC(content: LocationBasedListModel) {
        let viewModel = PlaceDetailViewModel(content: content)
        let vc = PlaceDetailViewController(viewModel: viewModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func presentLocationList(contents: [LocationBasedListModel]) {
        let listViewModel = PlaceListViewModel(locationList: contents)
        let listVC = PlaceListViewController(viewModel: listViewModel)
        let vc = UINavigationController(rootViewController: listVC)
        
        let detentIdentifier = UISheetPresentationController.Detent.Identifier("customDetent")
        let customDetent = UISheetPresentationController.Detent.custom(identifier: detentIdentifier) { _ in
            let screenHeight = UIScreen.main.bounds.height
            return screenHeight * 0.878912
        }
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [customDetent]
            sheet.preferredCornerRadius = 30
        }
        
        navigationController.present(vc, animated: true)
    }
}
