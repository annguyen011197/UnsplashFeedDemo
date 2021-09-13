//
//  UnsplashService.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

enum UnsplashService {
    case fetchImageList(page: Int)
}

extension UnsplashService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
    var path: String {
        switch self {
        case .fetchImageList:
            return "/photos"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        [
            "Content-type": "application/json",
            "Authorization": "Bearer \(Env.appToken)"
        ]
    }
    
    var task: HTTPTask {
        switch self {
        case .fetchImageList:
            return .requestPlain
        }
    }
    
    var queryParams: [String : String] {
        switch self {
        case .fetchImageList(let page):
            return [
                "page": String(page)
            ]
        }
    }
}
