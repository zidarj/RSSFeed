//
//  RFImageTableViewCell.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import UIKit
protocol RFImageTableViewCellDelegate: AnyObject {
    func removeImage()
    func selectImage()
}
final class RFImageTableViewCell: UITableViewCell {
    static var height: CGFloat = 200.0
    
    @IBOutlet private weak var feedImageView: UIImageView!
    @IBOutlet private weak var removeButton: UIButton!
    private weak var delegate: RFImageTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        removeButton.setTitle("", for: .normal)
    }
    
    final func config(image: Data?, delegate: RFImageTableViewCellDelegate?) {
        self.delegate = delegate
        if let data = image,
           let decoded = try? PropertyListDecoder().decode(Data.self, from: data),
           let img = UIImage(data: decoded){
            feedImageView.image = img
            removeButton.isHidden = false
        } else {
            feedImageView.image = UIImage(named: "rss")
            removeButton.isHidden = true
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTouchImageView))
        feedImageView.addGestureRecognizer(tap)
        feedImageView.isUserInteractionEnabled = true
    }
    
    @IBAction private func onTouchRemoveButton(_ sender: UIButton) {
        feedImageView.image = UIImage(named: "rss")
        removeButton.isHidden = true
        if let delegate = delegate {
            delegate.removeImage()
        }
    }
    
    @objc private func onTouchImageView() {
        if let delegate = delegate {
            delegate.selectImage()
        }
    }
}
