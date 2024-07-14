//
//  LocationFavoriteViewController.swift
//  CamPlace
//
//  Created by Chung Wussup on 7/5/24.
//

import UIKit
import Combine

protocol LocationFavoriteDelegate: AnyObject {
    func pushDetialVC(content: LocationBasedListModel)
}

class LocationFavoriteViewController: UIViewController {

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
    
    private let viewModel = LocationFavoriteViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    weak var delegate: LocationFavoriteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavi()
        bindData()
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
//        self.navigationController?.navigationBar.topItem?.title = "즐겨찾기"
    }
    
    private func bindData() {
        viewModel.$locations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.listTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension LocationFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceListTableViewCell",
                                                       for: indexPath) as? PlaceListTableViewCell else {
            return UITableViewCell()
        }
        
        guard let content: LocationBasedListModel = viewModel.getLocationModel(index: indexPath.row)  else {
            return UITableViewCell()
        }

        cell.setupCell(viewModel: self.viewModel, content: content)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content: LocationBasedListModel = LocationBasedListModel(from: viewModel.locations[indexPath.row])
        
        delegate?.pushDetialVC(content: content)

    }
}
