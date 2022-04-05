//
//  RFInputFieldTableViewCell.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import UIKit
protocol RFInputFieldTableViewCellDelegate: AnyObject {
    func textFieldDidEndEditing(text: String?, type: RFInputFieldTableViewCell.InputType)
}
final class RFInputFieldTableViewCell: UITableViewCell {
    enum InputType {
        case name
        case url
    }
    @IBOutlet private weak var titleLabelView: UILabel!
    @IBOutlet private weak var inputTextField: UITextField!
    private weak var delegate: RFInputFieldTableViewCellDelegate?
    private var type: InputType = .name
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabelView.font = UIFont.boldSystemFont(ofSize: 17)
        inputTextField.font = UIFont.systemFont(ofSize: 15)
    }
    
    final func config(title: String,
                      placeholder: String?,
                      value: String?,
                      keyboardType: UIKeyboardType = .default,
                      type: InputType,
                      delegate: RFInputFieldTableViewCellDelegate?) {
        titleLabelView.text = title
        inputTextField.text = value
        inputTextField.placeholder = placeholder
        inputTextField.delegate = self
        inputTextField.keyboardType = keyboardType
        self.type = type
        self.delegate = delegate
    }
    
}
extension RFInputFieldTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let delegate = self.delegate {
            delegate.textFieldDidEndEditing(text: textField.text, type: self.type)
        }
    }
}
