//
//  NetworkService.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 12/09/2021.
//

import Foundation

protocol NetworkService {
    func fetchImageList(page: Int, completion: @escaping (Result<[ImageModel], Error>) -> Void)
    
}
