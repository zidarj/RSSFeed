//
//  RFFeedTableViewCell.swift
//  RSSFeed
//
//  Created by Josip Zidar on 06.04.2022..
//

import UIKit

final class RFFeedTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var feedImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 0
    }
    
    final func config(feed: RFFeed) {
        if let data = feed.image,
           let decoded = try? PropertyListDecoder().decode(Data.self, from: data),
           let img = UIImage(data: decoded) {
            feedImageView.image = img
        } else {
            feedImageView.image = UIImage(named: "rss")
        }
        
        titleLabel.text = feed.name
        descriptionLabel.text = feed.description
    }
}
