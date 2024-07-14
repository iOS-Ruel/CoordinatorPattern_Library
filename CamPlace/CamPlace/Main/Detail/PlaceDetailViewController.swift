//
//  PlaceDetailViewController.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/19/24.
//

import UIKit
import Combine

class PlaceDetailViewController: UIViewController {
    private lazy var detailTV: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.register(DetailImageTableViewCell.self, forCellReuseIdentifier: "DetailImageTableViewCell")
        tv.register(DetailMapTableViewCell.self, forCellReuseIdentifier: "DetailMapTableViewCell")
        tv.register(DetailInfoTableViewCell.self, forCellReuseIdentifier: "DetailInfoTableViewCell")
        return tv
    }()
    
    private let viewModel: PlaceDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var cellType: [DetailCellType] = []
    
    
    init(viewModel: PlaceDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        title = viewModel.getContentTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavi()
        setupUI()
        bindViewModel()
        updateRightButtonVisibility()
    }
    
    private func setupNavi() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(dismissView))
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        view.addSubview(detailTV)
        NSLayoutConstraint.activate([
            detailTV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailTV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailTV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailTV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
         viewModel.$cellType
             .receive(on: RunLoop.main)
             .sink { [weak self] cellTypes in
                self?.cellType = cellTypes
                 self?.detailTV.reloadData()
             }
             .store(in: &cancellables)
     }

    private func updateRightButtonVisibility() {
        if let navigationController = self.navigationController {
            let backButton = navigationController.viewControllers.count > 1
            navigationItem.rightBarButtonItem?.isHidden = backButton
        }
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: false)
    }
    
}


extension PlaceDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cellType[indexPath.row] {
        case .image(imageUrls: let images):
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailImageTableViewCell", for: indexPath) as? DetailImageTableViewCell {
                cell.setupCell(imageUrls: images)
                return cell
            }
        case .map(mapX: let mapX, mapY: let mapY, titleWithAdress: let title):
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailMapTableViewCell", for: indexPath) as? DetailMapTableViewCell {
                cell.setupCell(mapX: mapX, mapY: mapY, title: title)
                return cell
            }
        case .info(content: let content):
            if let cell = tableView.dequeueReusableCell(withIdentifier: "DetailInfoTableViewCell", for: indexPath) as? DetailInfoTableViewCell {
                cell.setupCell(content: content)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
