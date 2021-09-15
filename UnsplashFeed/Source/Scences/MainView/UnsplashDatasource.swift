//
//  UnsplashDatasource.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import UIKit

protocol DataSourceDelegate: NSObject {
    func loadMore(searchMode: Bool)
    func likeImage(id: String)
    func unlikeImage(id: String)
    func reloadData()
    func reloadRows(indexs: [IndexPath])
}

class UnsplashDatasource: NSObject, UITableViewDelegate, UITableViewDataSource {
    let cellIndentifier: String = "imageTableviewCell"
    
    private var source: DataSource = DataSource()
    weak var delegate: DataSourceDelegate?


    func loadNextData(_ list: [ImageModel]) {
        source.appendList(list, isSearch: false)
        delegate?.reloadData()
    }
    
    func loadNewSearchData(_ list: [ImageModel]) {
        source.searchMode = true
        source.resetSearch()
        loadNextSearchData(list)
    }
    
    func loadNextSearchData(_ list: [ImageModel]) {
        source.appendList(list, isSearch: true)
        delegate?.reloadData()
    }
    
    func resetNormalMode() {
        source.searchMode = false
        delegate?.reloadData()
    }
    
    func refresh(_ model: ImageModel) {
        if let index = source.refreshItem(model) {
            delegate?.reloadRows(indexs: [IndexPath(row: index, section: 0)])
        }
    }

    func register(_ tbView: UITableView) {
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIndentifier)
        tbView.estimatedRowHeight = 44
        tbView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        source.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? ImageTableViewCell else {
            fatalError()
        }
        cell.delegate = self
        if let cellData = source.data[safe: indexPath.row] {
            cell.loadData(cellData) { width, height in
                tableView.beginUpdates()
                cell.updateHeightConstraint(width, height)
                tableView.endUpdates()
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.height
        let contentOffsetY = scrollView.contentOffset.y
        let distance = scrollView.contentSize.height - contentOffsetY
        if distance < height {
            delegate?.loadMore(searchMode: source.searchMode)
        }
    }
    
    struct DataSource {
        private var searchData: [ImageModel] = []
        private var normalData: [ImageModel] = []
        var searchMode: Bool = false
        var data: [ImageModel] {
            searchMode ? searchData : normalData
        }
        
        mutating func appendList(_ list: [ImageModel], isSearch: Bool) {
            if isSearch {
                searchData += list
            } else {
                normalData += list
            }
        }
        
        mutating func resetSearch() {
            searchData = []
        }
        
        mutating func refreshItem(_ model: ImageModel) -> Int? {
            guard let id = model.id else { return nil }
            var normalIndex: Int?
            if let index = normalData.firstIndex(where: { $0.id == id }) {
                normalData[index] = model
                normalIndex = index
            }
            var searchIndex: Int?
            if let index = searchData.firstIndex(where: { $0.id == id }) {
                searchData[index] = model
                searchIndex = index
            }
            
            return searchMode ? searchIndex : normalIndex
        }
    }
}

extension UnsplashDatasource: ImageTableCellDelegate {
    func onLikeTouchUp(_ data: ImageModel) {
        guard let id = data.id else { return }
        data.likedByUser ? delegate?.unlikeImage(id: id) : delegate?.likeImage(id: id)
    }
}

