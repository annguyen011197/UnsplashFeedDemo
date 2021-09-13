//
//  MainViewVM.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 12/09/2021.
//

import Foundation

class MainViewVM {
    struct Input {
        let viewDidLoad: PublishSubject<Void>
    }
    
    struct Output {
        let loaded: PublishSubject<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        let load = PublishSubject<Bool>()
        input.viewDidLoad.subscribe { _ in
            load.nextValue(true)
        }
        return Output(loaded: load)
    }
}
