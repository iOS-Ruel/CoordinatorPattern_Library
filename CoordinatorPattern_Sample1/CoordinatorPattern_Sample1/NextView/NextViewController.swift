//
//  NextViewController.swift
//  CoordinatorPattern_Sample1
//
//  Created by Chung Wussup on 7/14/24.
//

import UIKit

protocol NextViewControllerDelegate {
    func popViewController()
}

class NextViewController: UIViewController {

    var delegate: NextViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.delegate?.popViewController()
    }
    
    
}

