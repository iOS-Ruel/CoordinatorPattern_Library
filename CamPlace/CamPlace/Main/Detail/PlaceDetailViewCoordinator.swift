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
    var childCoordinator: [Coordinator] = []
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
        print("startPresent")
        if let presentedViewController = navigationController.presentedViewController {
            presentedViewController.dismiss(animated: false) { [weak self] in
                self?.presentDetailViewController()
            }
        } else {
            presentDetailViewController()
        }
    }
    
    private func presentDetailViewController() {
        let detailView = PlaceDetailViewController(viewModel: viewModel)
        let vc = UINavigationController(rootViewController: detailView)
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: false)
    }
    
}
