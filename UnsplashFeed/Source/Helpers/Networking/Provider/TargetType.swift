//
//  TargetType.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

protocol TargetType {

    var baseURL: URL { get }

    var path: String { get }

    var method: HTTPMethod { get }

    var headers: [String: String]? { get }
    
    var task: HTTPTask { get }
    
    var queryParams: [String: String] { get }
}
