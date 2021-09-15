//
//  GalleryWork.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

class GalleryWorker {
    typealias SearchRequest = (request: NetworkRequest?, query: String, page: Int)
    private var cachedRequest: [String: Any] = [:]
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
    
    func searchImage(query: String, page: Int, completion: @escaping (GalleryViewModel.ImageListResponse, Bool) -> Void) {
        if let currentRequest = cachedRequest["searchImage"] as? SearchRequest, let request = currentRequest.request {
            if query == currentRequest.query, page == currentRequest.page {
                completion(([], false, ""), true)
                return
            }
            request.cancel()
        }
        let request = API.shared.searchImageList(query: query, page: page) { result in
            switch result {
            case.success(let models):
                completion((models.results ?? [], false, ""), false)
            case .failure(let err):
                completion(([], true, err.localizedDescription), false)
            }
        }
        cachedRequest["searchImage"] = (request: request, query: query, page: page)
    }
}
