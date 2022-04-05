//
//  RFFeedViewModel.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import Foundation
import UIKit

final class RFFeedViewModel {
    enum Cells {
        case image
        case name
        case url
        case description
        case saveButton
    }
    
    private(set) var feed: RFFeed?
    private(set) var structure: [Cells] = [.image, .name, .url, .description, .saveButton]
    
    init(feed: RFFeed?) {
        self.feed = feed ?? RFFeed(with: "", image: nil, description: "", url: "")
    }
    
    final func saveImage(image: UIImage) {
        guard let feed = feed else {
            return
        }
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        feed.image = encoded
    }
    
    final func removeImage() {
        guard let feed = feed else {
            return
        }
        feed.image = nil
    }
    
}
extension RFFeedViewModel: RFInputFieldTableViewCellDelegate {
    func textFieldDidEndEditing(text: String?, type: RFInputFieldTableViewCell.InputType) {
        guard let feed = self.feed else { return }
        switch type {
        case .name:
            feed.name = text ?? ""
            
        case .url:
            feed.url = (text ?? "").trim()
            
        }
    }
}
extension RFFeedViewModel: RFDescriptionTableViewCellDelegate {
    func textViewDidEndEditing(text: String?) {
        guard let feed = self.feed else { return }
        feed.description = text ?? ""
    }
}
