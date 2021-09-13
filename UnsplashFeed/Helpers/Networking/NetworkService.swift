//
//  NetworkService.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 12/09/2021.
//

import Foundation

protocol NetworkService {
    func fetchImageList(completion: @escaping (NetworkResult<[ImageModel], Error>) -> Void)
    
}

enum NetworkResult<Success, Failure> where Failure : Error {
    case success(Success)
    case failure(Failure)
}

class NetworkServiceImpl: NetworkService {

    let provider = NetworkProvider<UnsplashService>()
    func fetchImageList(completion: @escaping (NetworkResult<[ImageModel], Error>) -> Void) {
        provider.request(.fetchImageList) { result in
            completion(DataHandler().handlerResult(result))
        }
    }

}

class DataHandler {
    func handlerResult<T: Codable>(_ result: Result) -> NetworkResult<T, Error> {
        switch result {
        case .success(let data):
            return parseData(data)
        case .failed(let err):
            return .failure(err)
        }
    }
    
    private func parseData<T: Codable>(_ data: Data) -> NetworkResult<T, Error>{
        do {
            let json = JSONDecoder()
            let res = try json.decode(T.self, from: data)
            return .success(res)
        } catch _ {
            return .failure(NetworkError.parseDataFail)
        }
    }
}


enum UnsplashService {
    case fetchImageList
}

extension UnsplashService: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
    var path: String {
        switch self {
        case .fetchImageList:
            return "/photos"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String]? {
        [
            "Content-type": "application/json",
            "Authorization": "Bearer pmUERTAa1VdCXgkU5pntHqKk-R2s7ues7A2Ll9Ft2OI"
        ]
    }
    
    var task: HTTPTask {
        switch self {
        case .fetchImageList:
            return .requestPlain
        }
    }
    
    var queryParams: [String : String] {
        switch self {
        case .fetchImageList:
            return [
                "page": "1"
            ]
        }
    }
    
    
}

enum HTTPMethod {
    case get, post
    
    func toString() -> String {
        switch self {
        case .get:
            return "get"
        case .post:
            return "post"
        }
    }
}

enum HTTPTask {
    case requestPlain
    case requestData(Data)
    case requestParameters(parameters: [String: Any])
}

protocol TargetType {

    var baseURL: URL { get }

    var path: String { get }

    var method: HTTPMethod { get }

    var headers: [String: String]? { get }
    
    var task: HTTPTask { get }
    
    var queryParams: [String: String] { get }
}

enum Result {
    case success(Data)
    case failed(Error)
}

enum NetworkError: Error {
    case parseDataFail
    case nonError
}

class NetworkProvider<T: TargetType> {
    func request(_ target: T, completion: @escaping (Result) -> Void) {
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

extension URL {

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
