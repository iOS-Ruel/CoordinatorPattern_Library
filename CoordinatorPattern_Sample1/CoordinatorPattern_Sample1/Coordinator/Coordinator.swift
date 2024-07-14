//
//  Coordinator.swift
//  CoordinatorPattern_Sample1
//
//  Created by Chung Wussup on 7/14/24.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}
