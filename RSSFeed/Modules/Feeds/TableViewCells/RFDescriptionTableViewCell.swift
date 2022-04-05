//
//  RFDescriptionTableViewCell.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import UIKit
protocol RFDescriptionTableViewCellDelegate: AnyObject {
    func textViewDidEndEditing(text: String?)
}
final class RFDescriptionTableViewCell: UITableViewCell {
    static var height: CGFloat = 150.0
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    private weak var delegate: RFDescriptionTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descriptionTextView.font = UIFont.systemFont(ofSize: 15)
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.borderColor = UIColor.blackColor.cgColor
    }
    
    final func config(description: String?, title: String, delegate: RFDescriptionTableViewCellDelegate?) {
        titleLabel.text = title
        descriptionTextView.text = description
        descriptionTextView.delegate = self
        self.delegate = delegate
    }
    
}
extension RFDescriptionTableViewCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if let delegate = self.delegate {
            delegate.textViewDidEndEditing(text: textView.text)
        }
    }
}
