//
//  MainViewController.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 12/09/2021.
//

import UIKit

protocol GalleryDislay: NSObject {
    func displayNextListImage(model: [ImageModel])
    func displaySearcListImage(model: [ImageModel], shouldReset: Bool)
    func displayError(error: String)
    func likeImageRefresh(model: ImageModel)
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var interactor = GalleryInteractor()
    lazy var presenter = GalleryPresenter()
    lazy var datasource = UnsplashDatasource()
    
    private var throttle = Throttler(seconds: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        uiSetup()
        datasource.register(tableView)
        binding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        interactor.fetchImageRequest()
    }
    
    private func binding() {
        datasource.delegate = self
        presenter.display = self
        interactor.presenter = presenter
    
        searchBar.delegate = self
    }
    
    private func uiSetup() {
        titleLabel.text = Strings.title.localize()
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 30)
        
        searchBar.placeholder = Strings.searchPhoto.localize()
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .onDrag
    }
    
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        guard let query = searchBar.text else { return }
        interactor.searchImageRequest(query)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            datasource.resetNormalMode()
            return
        }
        
        throttle.throttle { [weak self] in
            self?.interactor.searchImageRequest(searchText)
        }
    }
}

extension MainViewController: GalleryDislay {
    func displaySearcListImage(model: [ImageModel], shouldReset: Bool) {
        shouldReset ? datasource.loadNewSearchData(model) : datasource.loadNextSearchData(model)
    }
    
    
    func displayNextListImage(model: [ImageModel]) {
        datasource.loadNextData(model)
    }
    
    func displayError(error: String) {
        let alert = UIAlertController.init(title: Strings.error.localize(), message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.cancel.localize(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func likeImageRefresh(model: ImageModel) {
        datasource.refresh(model)
    }
}

extension MainViewController: DataSourceDelegate {
    func unlikeImage(id: String) {
        interactor.unlikeImageRequest(id)
    }
    
    func reloadRows(indexs: [IndexPath]) {
        tableView.reloadRows(at: indexs, with: .none)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func likeImage(id: String) {
        interactor.likeImageRequest(id)
    }
    
    func loadMore(searchMode: Bool) {
        if searchMode, let query = searchBar.text, !query.isEmpty {
            interactor.searchImageRequest(query)
        } else {
            interactor.fetchImageRequest()
        }
    }
}
