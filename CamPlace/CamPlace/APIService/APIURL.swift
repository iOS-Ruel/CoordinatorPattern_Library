//
//  APIURL.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/25/24.
//

import Foundation

enum APIURL {
    case baseList
    case locationBasedList
    case searchList
    case imageList
    case basedSyncList
    
    var urlString: String {
        let baseURL = "https://apis.data.go.kr/B551011/GoCamping"
        
        switch self {
        case .baseList:
            return baseURL + "/basedList"
        case .locationBasedList:
            return baseURL + "/locationBasedList"
        case .searchList:
            return baseURL + "/searchList"
        case .imageList:
            return baseURL + "/imageList"
        case .basedSyncList:
            return baseURL + "/basedSyncList"
        }
    }
}
