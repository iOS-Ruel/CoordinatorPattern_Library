//
//  LocationFavoriteViewModel.swift
//  CamPlace
//
//  Created by Chung Wussup on 7/5/24.
//

import Foundation
import Combine

class LocationFavoriteViewModel: PlaceListProtocol {

    private var cancellables: Set<AnyCancellable> = []
    
    @Published var locations: [Location] = []
    
    init() {
        bindData()
    }
    
    private func bindData() {
        CoreDataManager.shared.$locations
            .sink { [weak self] locations in
                self?.locations = locations
            }
            .store(in: &cancellables)
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
    
    func locationListCount() -> Int {
        return locations.count
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
    
    func getLocationModel(index: Int) -> LocationBasedListModel? {
        return LocationBasedListModel(from: locations[index])
    }    
}
