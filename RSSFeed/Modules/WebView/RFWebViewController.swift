//
//  RFWebViewController.swift
//  RSSFeed
//
//  Created by Josip Zidar on 06.04.2022..
//

import UIKit
import WebKit
final class RFWebViewController: RFViewController {

    @IBOutlet weak var webView: WKWebView!
    private var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        self.showProgress()
        if let url = url {
            let req = URLRequest(url: url)
            webView.load(req)
        } else {
            dismissProgress()
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    final func config(feed: RFFeed) {
        self.url = URL(string: feed.url)
        title = feed.name
    }
}
extension RFWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.dismissProgress()
    }
}
