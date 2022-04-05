//
//  RFButtonTableViewCell.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import UIKit
protocol RFButtonTableViewCellDelegate: AnyObject {
    func onTouchButton()
}
final class RFButtonTableViewCell: UITableViewCell {
    @IBOutlet private weak var saveButton: UIButton!
    private weak var delegate: RFButtonTableViewCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    final func config(title: String, delegate: RFButtonTableViewCellDelegate) {
        self.delegate = delegate
        saveButton.setTitle(title, for: .normal)
    }
    
    @IBAction func onTouchSaveButton(_ sender: Any) {
        delegate.onTouchButton()
    }
}
