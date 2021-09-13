//
//  MainViewController.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 12/09/2021.
//

import UIKit

protocol GalleryDislay: NSObject {
    func displayNextListImage(model: [ImageModel])
    func displayError(error: String)
}

class MainViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var interactor = GalleryInteractor()
    lazy var presenter = GalleryPresenter()
    lazy var datasource = UnsplashDatasource()
    
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
        presenter.display = self
        interactor.presenter = presenter
    
    }
    
    private func uiSetup() {
        titleLabel.text = Strings.title.localize()
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 30)
        
        searchBar.placeholder = Strings.searchPhoto.localize()
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
}

extension MainViewController: GalleryDislay {
    func displayNextListImage(model: [ImageModel]) {
        datasource.loadNextData(model)
        tableView.reloadData()
    }
    
    func displayError(error: String) {
        let alert = UIAlertController.init(title: Strings.error.localize(), message: error, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}
