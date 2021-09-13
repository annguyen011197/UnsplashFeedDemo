//
//  Enums.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation


enum HTTPMethod {
    case get, post
    
    func toString() -> String {
        switch self {
        case .get:
            return "get"
        case .post:
            return "post"
        }
    }
}

enum HTTPTask {
    case requestPlain
    case requestData(Data)
    case requestParameters(parameters: [String: Any])
}


enum NetworkResult {
    case success(Data)
    case failed(Error)
}

enum NetworkError: Error {
    case parseDataFail
    case nonError
}
