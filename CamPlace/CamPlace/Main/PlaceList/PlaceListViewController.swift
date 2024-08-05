//
//  PlaceListViewController.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/15/24.
//

import UIKit
import Combine

class PlaceListViewController: UIViewController {

    private lazy var listTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 100
        tv.backgroundColor = .white
        tv.register(PlaceListTableViewCell.self, forCellReuseIdentifier: "PlaceListTableViewCell")
        return tv
    }()
    
    init(viewModel: PlaceListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: PlaceListViewModel
    var coordinator: PlaceListViewCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavi()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(listTableView)
        
        NSLayoutConstraint.activate([
            listTableView.topAnchor.constraint(equalTo: view.topAnchor),
            listTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavi() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        title = "목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(dismissView))
    }
    
    
    //TODO: - 굳이 combine을 써야할까?
    private func bindTableView() {
        viewModel.$locationList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.listTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
    
    
}

extension PlaceListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceListTableViewCell",
                                                       for: indexPath) as? PlaceListTableViewCell else {
            return UITableViewCell()
        }
        
        guard let content = viewModel.getLocationModel(index: indexPath.row) else {
            return UITableViewCell()
        }
        
        cell.setupCell(viewModel: self.viewModel, content: content)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let content = viewModel.getLocationModel(index: indexPath.row) {
            print("tableview cell select")
            coordinator?.showDetail(content: content)
        }
    }
    
    
}
