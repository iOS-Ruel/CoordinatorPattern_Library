//
//  MainMapViewModel.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/15/24.
//

import Foundation
import Combine

class MainMapViewModel {
    private let service = APIService()
    private var cancellables = Set<AnyCancellable>()
    @Published var locationList: [LocationBasedListModel] = []
    @Published var errorMessage: String?
    
    func getLocationList(mapX: String, mapY: String, radius: String) {
        service.getLocationBasedList(mapX: mapX, mapY: mapY, radius: radius,
                                     type: LocationBasedListModel.self)
            .map { $0.response.body.items.item }
            .catch { [weak self] error -> Just<[LocationBasedListModel]> in
                self?.errorMessage = error.localizedDescription
                 return Just([])
            }
            .assign(to: &$locationList)
//            .assign(to: \.locationList, on: self)
//            .store(in: &cancellables)
    }
    
    
    
    func getLocationContent(title: String) -> LocationBasedListModel? {
        return locationList.first { $0.title == title }
    }
}
