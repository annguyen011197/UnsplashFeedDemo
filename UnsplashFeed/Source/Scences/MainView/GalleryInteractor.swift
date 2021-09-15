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
    private var progress: ShareLoading = ShareLoading()
    
    init() {
        progress.loadingBlock = { [weak self] loading in
            self?.presenter?.progress(isLoading: loading)
        }
    }
    func fetchImageRequest() {
        guard !progress.isLoading else { return }
        progress.loading()
        worker.fetchImage(page: page) { [weak presenter, weak self] response in
            self?.progress.finish()
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
        progress.loading()
        worker.searchImage(query: query, page: page) { [weak presenter, weak self] response, isCancelled in
            self?.progress.finish()
            guard !isCancelled else { return }
            presenter?.presentSearchResult(response: response, shouldReset: shouldReset)
        }
    }
    
}
