//
//  Env.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

class Env {
    private static let instance = Env()
    
    static let appToken: String = instance.value(for: "AppToken")
    let info: [String: Any] = {
        guard let info = Bundle.main.infoDictionary else {
            fatalError()
        }
        return info
    }()
    private init () { }
    
    private func value(for key: String) -> String {
        guard let str = info[key] as? String else {
            fatalError()
        }
        
        return str
    }
}
