//
//  GalleryViewModel.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

struct GalleryViewModel {
    typealias ImageListResponse = (imageList: [ImageModel], isError: Bool, message: String)
    typealias LikeResponse = (image: LikeImageModel?, isError: Bool, message: String)
}
