//
//  ShareLoading.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 16/09/2021.
//

import Foundation

class ShareLoading {
    private var count: Int = 0 {
        didSet {
            self.loadingBlock(isLoading)
        }
    }
    private let _lock = NSRecursiveLock()
    var loadingBlock: (Bool) -> Void = { _ in }
    var isLoading: Bool { count > 0 }
    func loading() {
        _lock.lock()
        self.count += 1
        _lock.unlock()
    }
    
    func finish() {
        _lock.lock()
        self.count -= 1
        _lock.unlock()
    }
}
