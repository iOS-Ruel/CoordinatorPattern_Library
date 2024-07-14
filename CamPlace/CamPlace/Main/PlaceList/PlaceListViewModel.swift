//
//  PlaceListViewModel.swift
//  CamPlace
//
//  Created by Chung Wussup on 7/8/24.
//

import Foundation
import Combine

protocol PlaceListProtocol {
    func locationListCount() -> Int
    
    func getLocationModel(index: Int) -> LocationBasedListModel?
    
    func isFavorite(content: LocationBasedListModel) -> AnyPublisher<Bool, Never>?
    func doFavoriteModel(locationContent: LocationBasedListModel) -> AnyPublisher<Bool, Never>?
}


class PlaceListViewModel: PlaceListProtocol {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var locationList: [LocationBasedListModel]
    
    init(locationList: [LocationBasedListModel]) {
        self.locationList = locationList
    }
    
    func locationListCount() -> Int {
        return locationList.count
    }
    
    func getLocationModel(index: Int) -> LocationBasedListModel? {
        return locationList[index]
    }
    
    func doFavoriteModel(locationContent: LocationBasedListModel) -> AnyPublisher<Bool, Never>? {
        Future<Bool, Never> { promise in
            CoreDataManager.shared.hasData(content: locationContent)
                .sink(receiveCompletion: { _ in },
                      receiveValue: { hasData in
                    if hasData {
                        CoreDataManager.shared.deleteData(content: locationContent)
                    } else {
                        CoreDataManager.shared.createData(content: locationContent)
                    }
                    promise(.success(!hasData))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    func isFavorite(content: LocationBasedListModel) -> AnyPublisher<Bool, Never>? {
        Future<Bool, Never> { promise in
            
            CoreDataManager.shared.hasData(content: content)
                .sink(receiveCompletion: { _ in },
                      receiveValue: { hasData in
                    promise(.success(hasData))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
        
    }
    
}
