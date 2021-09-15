//
//  API.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 12/09/2021.
//

import Foundation

class API: NetworkService {
    
    static let shared = API()
    private let provider = NetworkProvider<UnsplashService>()
    private init() { }
    
    func fetchImageList(page: Int, completion: @escaping (Result<[ImageModel], Error>) -> Void) {
        provider.request(.fetchImageList(data: Request.FetchImage(page: page))) { result in
            completion(DataHandler().handlerResult(result))
        }
    }
    
    func likeImage(id: String, completion: @escaping (Result<LikeImageModel, Error>) -> Void) {
        provider.request(.likeImage(id: id, isUnlike: false)) { result in
            completion(DataHandler().handlerResult(result))
        }
    }
    
    func unlikeImage(id: String, completion: @escaping (Result<LikeImageModel, Error>) -> Void) {
        provider.request(.likeImage(id: id, isUnlike: true)) { result in
            completion(DataHandler().handlerResult(result))
        }
    }
    
    func searchImageList(query: String, page: Int, completion: @escaping (Result<SearchImageModel, Error>) -> Void) -> NetworkRequest? {
        provider.request(.searchImage(data: Request.SearchImage(query: query, page: page))) { result in
            completion(DataHandler().handlerResult(result))
        }
    }
}
