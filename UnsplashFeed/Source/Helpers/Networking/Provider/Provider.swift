//
//  Provider.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

class NetworkProvider<T: TargetType> {
    func request(_ target: T, completion: @escaping (NetworkResult) -> Void) {
        guard let url = NetworkProvider.buildURLRequest(target) else { return }
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let err = error {
                completion(.failed(err))
                return
            }
            
            guard let data = data else {
                completion(.failed(NetworkError.parseDataFail))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    private class func buildURLRequest(_ target: T) -> URLRequest? {
        guard var urlComponents = URLComponents(url: URL(target: target), resolvingAgainstBaseURL: false) else {
            return nil
        }
        urlComponents.queryItems = target.queryParams.map({ entry -> URLQueryItem  in
            URLQueryItem(name: entry.key, value: entry.value)
        })
        guard let url = urlComponents.url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = target.method.toString()
        (target.headers ?? [:]).forEach { header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return urlRequest
    }
}

fileprivate extension URL {

    /// Initialize URL from Moya's `TargetType`.
    init<T: TargetType>(target: T) {
        let targetPath = target.path
        if targetPath.isEmpty {
            self = target.baseURL
        } else {
            self = target.baseURL.appendingPathComponent(targetPath)
        }
    }
}