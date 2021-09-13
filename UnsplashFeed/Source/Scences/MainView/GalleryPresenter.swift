//
//  GalleryPresenter.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation
protocol Presenter { }
class GalleryPresenter: Presenter {
    weak var display: GalleryDislay?
    func presentFetchResults(response: GalleryViewModel.Response) {
        DispatchQueue.main.async { [weak display] in
            if response.isError {
                display?.displayError(error: response.message)
            } else {
                display?.displayNextListImage(model: response.imageList)
            }
        }
    }
}
