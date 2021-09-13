//
//  GalleryInteractor.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

protocol GalleryLogic{
    func fetchImageRequest()
}

class GalleryInteractor: GalleryLogic {
    weak var presenter: GalleryPresenter?
    private lazy var worker: GalleryWorker = GalleryWorker()
    private var page: Int = 0
    func fetchImageRequest() {
        page += 1
        worker.fetchImage(page: page) { [weak presenter] response in
            presenter?.presentFetchResults(response: response)
        }
    }
}
