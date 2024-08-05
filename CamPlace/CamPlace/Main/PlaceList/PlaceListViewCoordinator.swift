//
//  PlaceListViewCoordinator.swift
//  CamPlace
//
//  Created by Chung Wussup on 8/5/24.
//

import Foundation
import UIKit

class PlaceListViewCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    var viewModel: PlaceListViewModel
    
    init(navigationController: UINavigationController, viewModel: PlaceListViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func start() {
        let listViewModel = viewModel
        let listVC = PlaceListViewController(viewModel: listViewModel)
        listVC.coordinator = self
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



extension PlaceListViewCoordinator {
    func showDetail(content: LocationBasedListModel) {
        let viewModel = PlaceDetailViewModel(content: content)
        let detailCoordinator = PlaceDetailViewCoordinator(navigationController: navigationController, viewModel: viewModel)
        detailCoordinator.parentCoordinator = self
        childCoordinator.append(detailCoordinator)
        detailCoordinator.startPresent()
    }
}
