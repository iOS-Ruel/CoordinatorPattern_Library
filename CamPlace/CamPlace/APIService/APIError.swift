//
//  APIError.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/25/24.
//

import Foundation


enum APIError: Error  {
    case apiKeyError
    case urlError
    case stringURLError
    case httpError
    case decodeError
    case fetchError
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .apiKeyError:
            return NSLocalizedString("Description of invalid API KEY", comment: "Invalid APIKEY")
        case .urlError:
            return NSLocalizedString("Description of invalid URL", comment: "Invalid URL")
        case .stringURLError:
            return NSLocalizedString("Description of invalid URL String", comment: "Invalid URL String")
        case .httpError:
            return NSLocalizedString("Description of invalid HTTP Code", comment: "Invalid HTTP State Code")
        case .decodeError:
            return NSLocalizedString("Description of invalid Decode", comment: "Invalid Decode")
        case .fetchError:
            return NSLocalizedString("Description of invalid Fetch", comment: "Invalid Fetch")
        }
    }
}
