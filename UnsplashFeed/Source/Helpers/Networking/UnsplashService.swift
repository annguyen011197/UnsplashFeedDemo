//
//  UnsplashService.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

enum UnsplashService {
    case fetchImageList(data: Request.FetchImage)
    case searchImage(data: Request.SearchImage)
    case likeImage(id: String, isUnlike: Bool)
}

extension UnsplashService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
    var path: String {
        switch self {
        case .fetchImageList:
            return "/photos"
        case .likeImage(let id, _):
            return "/photos/\(id)/like"
        case .searchImage:
            return "/search/photos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchImageList, .searchImage:
            return .get
        case .likeImage(_, let isUnlike):
            return isUnlike ? .delete : .post
        }
    }
    
    var headers: [String : String]? {
        [
            "Content-type": "application/json",
            "Authorization": "Bearer \(Env.appToken)"
        ]
    }
    
    var task: HTTPTask {
        switch self {
        case .fetchImageList, .likeImage, .searchImage:
            return .requestPlain
        }
    }
    
    var queryParams: [String : String] {
        switch self {
        case .fetchImageList(let data):
            return data.dictionary()
        case .searchImage(let data):
            return data.dictionary()
        default:
            return [:]
        }
    }
}
