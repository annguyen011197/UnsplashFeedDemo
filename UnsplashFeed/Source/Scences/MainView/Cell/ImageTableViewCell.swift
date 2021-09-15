//
//  ImageTableViewCell.swift
//  UnsplashFeed
//
//  Created by An Nguyen on 14/09/2021.
//

import UIKit
import SDWebImage

protocol ImageTableCellDelegate: NSObject {
    func onLikeTouchUp(_ data: ImageModel)
}

class ImageTableViewCell: UITableViewCell {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    private var data: ImageModel?
    weak var delegate: ImageTableCellDelegate?
    private var throttle: Throttler = Throttler(seconds: 0.3)
    override func prepareForReuse() {
        mainImageView.sd_cancelCurrentImageLoad()
        updated = false
        data = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        uiSetup()
    }

    private func uiSetup() {
        mainImageView.layer.cornerRadius = 8
        
        userNameLabel.font = .boldSystemFont(ofSize: 18)
        
        likeButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        likeButton.setTitleColor(UIColor.systemGreen, for: .normal)
        
        likeLabel.font = .systemFont(ofSize: 16)
        likeLabel.textColor = UIColor.lightGray
        
        mainImageView.contentMode = .scaleToFill
        
    }
    
    func loadData(_ data: ImageModel, completion: @escaping (CGFloat, CGFloat) -> Void) {
        defer {
            self.data = data
        }
        mainImageView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        
        userNameLabel.text = data.user?.username ?? ""
        likeButton.setTitle(data.likedByUser ? Strings.unlike.localize() : Strings.like.localize() , for: .normal)
        
        likeLabel.text = String(format: Strings.likes.localize(), data.likes)
        guard self.data?.id != data.id else { return }
        if let width = data.width, let height = data.height {
            completion(CGFloat(width), CGFloat(height))
        }
        mainImageView.sd_setImage(with: URL(string: data.urls?.full ?? "")) { [weak mainImageView] image, _, _, _ in
            guard let image = image else { return }
            mainImageView?.image = image
        }
    }
    private var updated = false
    func updateHeightConstraint(_ width: CGFloat, _ height: CGFloat) {
        guard !updated else { return }
        updated = true
        let imageWidth = mainImageView.frame.width
        let imageHeight = CGFloat(height)*imageWidth/CGFloat(width)
        imageHeightConstraint.constant = imageHeight
    }

    @IBAction func likeAction(_ sender: Any) {
        guard let data = self.data else { return }
        throttle.throttle { [weak self] in
            self?.delegate?.onLikeTouchUp(data)
        }
    }
}
