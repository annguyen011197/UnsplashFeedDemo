//
//  GalleryWork.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

class GalleryWorker {
    func fetchImage(page: Int, completion: @escaping (GalleryViewModel.ImageListResponse) -> Void) {
        API.shared.fetchImageList(page: page) { result in
            switch result {
            case.success(let models):
                completion((models, false, ""))
            case .failure(let err):
                completion(([], true, err.localizedDescription))
            }
        }
    }
    
    func likeImage(id: String, completion: @escaping (GalleryViewModel.LikeResponse) -> Void) {
        API.shared.likeImage(id: id) { result in
            switch result {
            case.success(let model):
                completion((model, false, ""))
            case .failure(let err):
                completion((nil, true, err.localizedDescription))
            }
        }
    }
    
    func unlikeImage(id: String, completion: @escaping (GalleryViewModel.LikeResponse) -> Void) {
        API.shared.unlikeImage(id: id) { result in
            switch result {
            case.success(let model):
                completion((model, false, ""))
            case .failure(let err):
                completion((nil, true, err.localizedDescription))
            }
        }
    }
    
    func searchImage(query: String, page: Int, completion: @escaping (GalleryViewModel.ImageListResponse) -> Void) {
        API.shared.searchImageList(query: query, page: page) { result in
            switch result {
            case.success(let models):
                completion((models.results ?? [], false, ""))
            case .failure(let err):
                completion(([], true, err.localizedDescription))
            }
        }
    }
}
