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
    var likes: Int
    var user: UserParam?
    var likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, urls, likes, user, likedByUser = "liked_by_user"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        urls = try values.decodeIfPresent(ImageUrlsParam.self, forKey: .urls)
        likes = try values.decodeIfPresent(Int.self, forKey: .likes) ?? 0
        user = try values.decodeIfPresent(UserParam.self, forKey: .user)
        likedByUser = try values.decodeIfPresent(Bool.self, forKey: .likedByUser) ?? false
    }
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
