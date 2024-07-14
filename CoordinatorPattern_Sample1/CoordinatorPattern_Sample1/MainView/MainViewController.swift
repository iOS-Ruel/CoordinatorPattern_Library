//
//  MainViewController.swift
//  CoordinatorPattern_Sample1
//
//  Created by Chung Wussup on 7/14/24.
//

import UIKit
import SnapKit

protocol MainViewControllerDelegate {
    func logout()
    func pushNextView()
}



class MainViewController: UIViewController {
    var delegate: MainViewControllerDelegate?
    
    private lazy var pushButton: UIButton = {
       let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(didPushButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(pushButton)
        pushButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        
        let item = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(logoutButtonDidTap))
        self.navigationItem.rightBarButtonItem = item
    }
    
    deinit {
        print("- \(type(of: self)) deinit")
    }
    
    @objc func logoutButtonDidTap() {
        self.delegate?.logout()
    }
    
    @objc func didPushButton() {
        self.delegate?.pushNextView()
    }
}
