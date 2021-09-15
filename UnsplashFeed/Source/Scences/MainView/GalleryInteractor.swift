//
//  GalleryInteractor.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

protocol GalleryLogic{
    func fetchImageRequest()
    func likeImageRequest(_ id: String)
    func unlikeImageRequest(_ id: String)
    func searchImageRequest(_ query: String)
}

class GalleryInteractor: GalleryLogic {
    weak var presenter: GalleryPresenter?
    private lazy var worker: GalleryWorker = GalleryWorker()
    private var page: Int = 1
    private var searchCache: (query: String, page: Int) = ("", 1)
    private var isLoading: Bool = false
    func fetchImageRequest() {
        guard !isLoading else { return }
        isLoading = true
        worker.fetchImage(page: page) { [weak presenter, weak self] response in
            self?.isLoading = false
            if !response.isError {
                self?.page += 1
            }
            presenter?.presentFetchResults(response: response)
        }
    }
    
    func likeImageRequest(_ id: String) {
        worker.likeImage(id: id) { [weak presenter] response in
            presenter?.likeImageRefresh(response: response)
        }
    }
    
    func unlikeImageRequest(_ id: String) {
        worker.unlikeImage(id: id) { [weak presenter] response in
            presenter?.likeImageRefresh(response: response)
        }
    }
    
    func searchImageRequest(_ query: String) {
        var page = 1
        var shouldReset = true
        if query == searchCache.query {
            page = searchCache.page + 1
            shouldReset = false
        } else {
            searchCache = (query, page)
        }
        worker.searchImage(query: query, page: page) { [weak presenter] response in
            presenter?.presentSearchResult(response: response, shouldReset: shouldReset)
        }
    }
    
}
