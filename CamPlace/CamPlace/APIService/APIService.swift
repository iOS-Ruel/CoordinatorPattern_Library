//
//  APIService.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/24/24.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func getLocationBasedList<T: BasedItem>(mapX: String, mapY: String, radius: String, type: T.Type) -> AnyPublisher<ApiResponse<T>, APIError>
    func getLocationImageList<T: BasedItem>(contentId: String, type: T.Type) -> AnyPublisher<ApiResponse<T>, APIError>
}

class APIService: APIServiceProtocol {
    
    func getLocationBasedList<T: BasedItem>(mapX: String, mapY: String, radius: String, type: T.Type) -> AnyPublisher<ApiResponse<T>, APIError> {
        let queryItems = [
            URLQueryItem(name: "numOfRows", value: "1000"),
            URLQueryItem(name: "MobileOS", value: "IOS"),
            URLQueryItem(name: "MobileApp", value: "TrekKo"),
            URLQueryItem(name: "mapX", value: mapX),
            URLQueryItem(name: "mapY", value: mapY),
            URLQueryItem(name: "radius", value: radius)
        ]
        return fetch(urlString: APIURL.locationBasedList.urlString, queryItems: queryItems, type: type)
            .mapError { _ in
                return APIError.fetchError
            }
            .eraseToAnyPublisher()
    }
    
    func getLocationImageList<T: BasedItem>(contentId: String, type: T.Type) -> AnyPublisher<ApiResponse<T>, APIError> {
        let queryItems = [
            URLQueryItem(name: "numOfRows", value: "10"),
            URLQueryItem(name: "MobileOS", value: "IOS"),
            URLQueryItem(name: "MobileApp", value: "TrekKo"),
            URLQueryItem(name: "contentId", value: contentId)
        ]
        return fetch(urlString: APIURL.imageList.urlString, queryItems: queryItems, type: type)
            .mapError { _ in
                return APIError.fetchError
            }
            .eraseToAnyPublisher()
    }
    
    private func fetch<T: BasedItem>(urlString: String, queryItems: [URLQueryItem], type: T.Type) -> AnyPublisher<ApiResponse<T>, APIError> {
        guard let apiKey = Bundle.main.apiKey else {
            print("API 키를 로드하지 못했습니다.")
            return Fail(error: .apiKeyError)
                .eraseToAnyPublisher()
        }
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = queryItems + [URLQueryItem(name: "serviceKey", value: apiKey), URLQueryItem(name: "_type", value: "json")]
        
        guard let url = urlComponents?.url else {
            return Fail(error: .urlError)
                .eraseToAnyPublisher()
        }
        
        var urlString = url.absoluteString
        urlString = urlString.replacingOccurrences(of: "%25", with: "%")
        
        guard let finalURL = URL(string: urlString) else {
            return Fail(error: .stringURLError)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: finalURL)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw APIError.httpError
                }
//                print("Debug: Received Data - \(String(data: data, encoding: .utf8) ?? "")")
                return data
            }
            .decode(type: ApiResponse<T>.self, decoder: JSONDecoder())
            .mapError { error in
                print("Debug: Decoding Error - \(error.localizedDescription)")
                return APIError.decodeError
            }
            .eraseToAnyPublisher()
    }
}
