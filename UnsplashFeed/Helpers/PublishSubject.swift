//
//  PublishSubject.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 12/09/2021.
//

import Foundation

class PublishSubject<T> {
    
    private var bind :(T) -> () = { _ in }

    private var value :T?
    
    init() {}
    
    func nextValue(_ value: T) {
        self.value = value
        bind(value)
    }
    
    func subscribe(_ onNext: @escaping (T) -> ()) {
        bind = onNext
    }
}
