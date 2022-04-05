//
//  RFWebViewControllerHelper.swift
//  RSSFeed
//
//  Created by Josip Zidar on 06.04.2022..
//

import Foundation
import UIKit

extension UIStoryboard {
    static let webView = UIStoryboard(name: "WebView", bundle: nil)
}

final class RFWebViewControllerHelper {
    private init() {}
    
    static func openRSSFeed(from vc: UIViewController, feed: RFFeed) {
        let view: RFWebViewController = UIStoryboard.webView.getController()
        view.config(feed: feed)
        vc.navigationController?.pushViewController(view, animated: true)
    }
}
