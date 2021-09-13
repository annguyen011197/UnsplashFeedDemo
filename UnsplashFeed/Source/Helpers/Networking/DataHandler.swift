//
//  DataHandler.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

class DataHandler {
    func handlerResult<T: Codable>(_ result: NetworkResult) -> Result<T, Error> {
        switch result {
        case .success(let data):
            return parseData(data)
        case .failed(let err):
            return .failure(err)
        }
    }
    
    private func parseData<T: Codable>(_ data: Data) -> Result<T, Error>{
        do {
            let json = JSONDecoder()
            let res = try json.decode(T.self, from: data)
            return .success(res)
        } catch _ {
            return .failure(NetworkError.parseDataFail)
        }
    }
}
