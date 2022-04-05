//
//  RFNetworkManager.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import Foundation

protocol RFNetworkRequestableDelegate: AnyObject {
    func didPerformRequest()
    func didReceiveError(_ error: Error)
    func didFetch()
    
}

struct RFNetworkManager {
    private init() {}
    private static let defaults = UserDefaults.standard
    static func loadFeeds(success: @escaping (([RFFeed]) -> Void),
                          failure: @escaping (Error) -> Void) {

        guard let data = defaults.value(forKey: "Feeds") as? Data else {
            OnMainThread {
                success([])
            }
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let feeds = try decoder.decode([RFFeed].self, from: data)
            OnMainThread {
                success(feeds)
            }
            
        } catch {
            OnMainThread {
                failure(error)
            }
        }
        
    }
    
    static func saveFeeds(feeds: [RFFeed],
                           success: @escaping (() -> Void),
                           failure: @escaping (Error) -> Void) {
        
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(feeds)
            RFNetworkManager.defaults.set(encodedData, forKey: "Feeds")
            RFNetworkManager.defaults.synchronize()
            OnMainThread {
                success()
            }
        } catch {
            OnMainThread {
                failure(error)
            }
        }
    }
}
