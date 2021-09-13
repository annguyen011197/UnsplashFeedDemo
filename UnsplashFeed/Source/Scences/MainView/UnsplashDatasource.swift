//
//  UnsplashDatasource.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import UIKit

class UnsplashDatasource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var data: [ImageModel] = []
//    var data: [String] = ["", "", "", ""]
    let cellIndentifier: String = "imageTableviewCell"
    func loadNextData(_ list: [ImageModel]) {
        data += list
    }

    func register(_ tbView: UITableView) {
        tbView.delegate = self
        tbView.dataSource = self
        tbView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIndentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentifier, for: indexPath) as? ImageTableViewCell else {
            fatalError()
        }
        if let cellData = data[safe: indexPath.row] {
            cell.loadData(cellData)
        }
        return cell
    }
    
    
}
