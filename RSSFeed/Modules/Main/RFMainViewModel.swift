//
//  RFMainViewModel.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import Foundation

final class RFMainViewModel {
    private weak var delegate: RFNetworkRequestableDelegate!
    private(set) var feeds: [RFFeed] = []
    init(delegate: RFNetworkRequestableDelegate) {
        self.delegate = delegate
        loadFeeds()
    }
    
    final func loadFeeds() {
        self.delegate.didPerformRequest()
        RFNetworkManager.loadFeeds { [weak self] feeds in
            guard let welf = self else { return }
            welf.feeds = feeds
            OnMainThread {
                welf.delegate.didFetch()
            }
        } failure: { [weak self] error in
            guard let welf = self else { return }
            OnMainThread {
                welf.delegate.didReceiveError(error)
            }
        }
    }
    
    final func saveFeeds() {
        self.delegate.didPerformRequest()
        RFNetworkManager.saveFeeds(feeds: self.feeds) { [weak self] in
            guard let welf = self else { return }
            OnMainThread {
                welf.delegate.didFetch()
            }
        } failure: { [weak self] error in
            guard let welf = self else { return }
            OnMainThread {
                welf.delegate.didReceiveError(error)
            }
        }

    }
    
    final func removeFeed(at index: Int) {
        self.feeds.remove(at: index)
        self.saveFeeds()
    }
    
}
extension RFMainViewModel: RFFeedViewControllerDelegate {
    func createFeed(feed: RFFeed) {
        self.feeds.append(feed)
        self.saveFeeds()
    }
}
