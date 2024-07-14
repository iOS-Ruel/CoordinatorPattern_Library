//
//  Extension_Bundle.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/17/24.
//

import Foundation

extension Bundle {
    var apiKey: String? {
        let key = (Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String)
        return key
    }
}
