//
//  ImageLoader.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation
import UIKit

class ImageLoader {
    typealias Completion = (Result<UIImage?, Error>) -> Void
    var imageCache = [String:UIImage]()
    static let shared = ImageLoader()
    private init() { }
    
    func loadImage(url str: String, completion: @escaping Completion) {
        guard let url = URL(string: str) else { return }
        if let image = imageCache[str] {
            completion(.success(image))
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, err in
            if let err = err {
                DispatchQueue.main.async {
                    completion(.failure(err))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.parseDataFail))
                }
                return
            }
            
            let image = UIImage(data: data)
            self?.imageCache[str] = image
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }.resume()
    }
}
