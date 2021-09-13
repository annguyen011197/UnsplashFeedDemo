//
//  ImageListModel.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 12/09/2021.
//

import Foundation

//struct ImageListModel: Codable {
//    
//}

struct ImageModel: Codable {
    var id: String?
    var urls: ImageUrlsParam?
    var likes: Int?
    var user: UserParam?
}

struct ImageUrlsParam: Codable {
    var raw: String?
    var full: String?
    var small: String?
    var thumb: String
}

struct UserParam: Codable {
    var username: String?
}
