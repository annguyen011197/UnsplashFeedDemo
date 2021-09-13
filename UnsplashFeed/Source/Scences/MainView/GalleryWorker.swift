//
//  GalleryWork.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import Foundation

class GalleryWorker {
    func fetchImage(page: Int, completion: @escaping (GalleryViewModel.Response) -> Void) {
        API.shared.fetchImageList(page: page) { result in
            switch result {
            case.success(let models):
                completion((models, false, ""))
            case .failure(let err):
                completion(([], true, err.localizedDescription))
            }
        }
    }
}
