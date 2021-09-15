//
//  GalleryPresenter.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

class GalleryPresenter {
    weak var display: GalleryDislay?
    func progress(isLoading: Bool) {
        DispatchQueue.main.async { [weak display] in
            display?.loadingIndicatorDisplay(isLoading: isLoading)
        }
    }
    
    func presentFetchResults(response: GalleryViewModel.ImageListResponse) {
        DispatchQueue.main.async { [weak display] in
            if response.isError {
                display?.displayError(error: response.message)
            } else {
                display?.displayNextListImage(model: response.imageList)
            }
        }
    }
    
    func likeImageRefresh(response: GalleryViewModel.LikeResponse) {
        DispatchQueue.main.async { [weak display] in
            if response.isError {
                display?.displayError(error: response.message)
            } else {
                guard let model = response.image?.photo else { return }
                display?.likeImageRefresh(model: model)
            }
        }
    }
    
    func presentSearchResult(response: GalleryViewModel.ImageListResponse, shouldReset: Bool) {
        DispatchQueue.main.async { [weak display] in
            if response.isError {
                display?.displayError(error: response.message)
            } else {
                display?.displaySearcListImage(model: response.imageList, shouldReset: shouldReset)
            }
        }
    }
}
