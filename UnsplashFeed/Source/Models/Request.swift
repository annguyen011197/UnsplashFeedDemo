//
//  FetchImageRequest.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 15/09/2021.
//

import Foundation



struct Request {
    
    struct FetchImage: Codable {
        var page: Int
        var itemPerPage: Int = 20
        
        enum CodingKeys: String, CodingKey {
            case page, itemPerPage = "per_page"
        }
    }
    
    struct SearchImage: Codable {
        var query: String
        var page: Int
        var itemPerPage: Int = 20
        
        enum CodingKeys: String, CodingKey {
            case query, page, itemPerPage = "per_page"
        }
    }
}

extension Encodable {
    func dictionary() -> [String: String] {
        (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: .allowFragments) as? [String: Any])?.mapValues({ String(describing: $0)
        }) ?? [:]
    }
}
