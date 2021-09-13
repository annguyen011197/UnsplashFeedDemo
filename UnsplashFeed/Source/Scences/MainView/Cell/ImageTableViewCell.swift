//
//  ImageTableViewCell.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uiSetup()
//        sample()
    }

    private func uiSetup() {
        mainImageView.layer.cornerRadius = 8
        
        userNameLabel.font = .boldSystemFont(ofSize: 18)
        
        likeButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        likeButton.setTitleColor(UIColor.systemGreen, for: .normal)
        
        likeLabel.font = .systemFont(ofSize: 16)
        likeLabel.textColor = UIColor.lightGray
        
    }
    
    func loadData(_ data: ImageModel) {
        imageHeightConstraint.constant = 70
        mainImageView.backgroundColor = .green
        
        userNameLabel.text = data.user?.username ?? ""
        likeButton.setTitle(data.likedByUser ? Strings.unlike.localize() : Strings.like.localize() , for: .normal)
        
        likeLabel.text = String(format: Strings.likes.localize(), data.likes)
//        mainImageView.sd
//        ImageLoader.shared.loadImage(url: data.urls?.full ?? "") { [weak mainImageView] result in
//            if case Result.success(let image) = result {
//                mainImageView?.image = image
//            }
//        }
    }
    
    private func sample() {
        imageHeightConstraint.constant = 70
        mainImageView.backgroundColor = .green
        userNameLabel.text = "User name"
        likeButton.setTitle("Like", for: .normal)
        likeLabel.text = "28 likes"
    }
}
