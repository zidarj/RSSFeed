//
//  RFFeedsControllerHelper.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import Foundation
import UIKit

extension UIStoryboard {
    static let feeds = UIStoryboard(name: "Feeds", bundle: nil)
}

final class RFFeedsControllerHelper {
    private init() {}
    
    static func createFeed(from vc: UIViewController, delegate: RFFeedViewControllerDelegate) {
        let view: RFFeedViewController = UIStoryboard.feeds.getController()
        view.config(feed: nil, delegate: delegate)
        vc.navigationController?.pushViewController(view, animated: true)
    }
}
