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
        provider.request(.fetchImageList(page: page)) { result in
            completion(DataHandler().handlerResult(result))
        }
    }
}
