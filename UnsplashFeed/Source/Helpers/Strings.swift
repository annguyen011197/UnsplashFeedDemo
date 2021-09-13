//
//  Strings.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

enum Strings: String  {
    case title = "title"
    case searchPhoto = "search_photo"
    case error = "error"
    case like = "like"
    case unlike = "unlike"
    case likes = "likes"
    
    func localize() -> String { rawValue.localized() }
}
