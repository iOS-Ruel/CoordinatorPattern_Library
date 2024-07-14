//
//  Coordinator.swift
//  CamPlace
//
//  Created by Chung Wussup on 7/13/24.
//

import Foundation


protocol Coordinator: AnyObject {
    var childCoordinator: [Coordinator] { get set }
    func start()
}
