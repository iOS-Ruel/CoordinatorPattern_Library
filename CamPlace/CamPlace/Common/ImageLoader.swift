//
//  ImageLoader.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/17/24.
//

import UIKit
import Combine

class ImageLoader {
    static func loadImageFromUrl(_ urlString: String) -> AnyPublisher<UIImage?, Never> {

        guard let url = URL(string: urlString) else {
            return Just(UIImage(systemName: "questionmark"))
                .eraseToAnyPublisher()
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        // 캐시된 데이터가 있는지 확인
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            return Just(image)
                .eraseToAnyPublisher()
        }
        
        // 네트워크 요청
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, response -> UIImage? in
                // 캐시에 데이터 저장
                let cachedResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cachedResponse, for: request)
                
                return UIImage(data: data)
            }
            .catch { _ in
                Just(UIImage(systemName: "questionmark"))
            }
            .eraseToAnyPublisher()
    }

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        ImageLoader.loadImageFromUrl(urlString)
            .receive(on: DispatchQueue.main)
            .sink { image in
                completion(image)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
}
