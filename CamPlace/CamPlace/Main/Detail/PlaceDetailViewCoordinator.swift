//
//  PlaceDetailViewCoordinator.swift
//  CamPlace
//
//  Created by Chung Wussup on 8/5/24.
//

import Foundation
import UIKit

class PlaceDetailViewCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: Coordinator?

    var viewModel: PlaceDetailViewModel
    
    init(navigationController: UINavigationController, viewModel: PlaceDetailViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel

    }
    
    func start() {
        let detailView = PlaceDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailView, animated: true)
    }
    
    func startPresent() {
        let detailView = PlaceDetailViewController(viewModel: viewModel)
        let vc = UINavigationController(rootViewController: detailView)
        vc.modalPresentationStyle = .fullScreen
        
        if let presentedViewController = navigationController.presentedViewController {
            presentedViewController.present(vc, animated: true, completion: nil)
        } else {
            navigationController.present(vc, animated: true, completion: nil)
        }
    }
}
