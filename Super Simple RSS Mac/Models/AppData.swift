//
//  AppData.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa
import FeedKit

class AppData {
    
    static let shared = AppData()
    
    var feedURLs: [URL?]
    var feeds: [Feed] = []
    
    private init() {
        
        feedURLs = []
        
        // add URLs from UserDefaults
        for feedStr in UserDefaults.feedStrs {
            
            guard let url = URL(string: feedStr) else { continue }
            feedURLs.append(url)
            feeds.append(Feed(url))
        }
    }
    
    static func addFeed(_ feedStr: String) {
        
        guard let url = URL(string: feedStr) else { return }
        
        AppData.shared.feedURLs.append(url)
        AppData.shared.feeds.append(Feed(url))
        UserDefaults.feedStrs.append(feedStr)
    }
    
    static func deleteFeed(_ feed: Feed) {
        
        if let index = AppData.shared.feeds.firstIndex(where: { $0 == feed }) {
            AppData.deleteFeed(at: index)
        }
    }
    
    static func deleteFeed(at index: Int) {
        
        AppData.shared.feedURLs.remove(at: index)
        AppData.shared.feeds.remove(at: index)
        
        var feedStrs = UserDefaults.feedStrs
        feedStrs.remove(at: index)
        UserDefaults.feedStrs = feedStrs
    }
    
    static func editFeed(_ feedStr: String, at index: Int) {
        
        guard let url = URL(string: feedStr) else { return }
        
        AppData.shared.feedURLs.remove(at: index)
        AppData.shared.feedURLs.insert(url, at: index)
        
        AppData.shared.feeds.remove(at: index)
        AppData.shared.feeds.insert(Feed(url), at: index)
        
        var feedStrs = UserDefaults.feedStrs
        feedStrs.remove(at: index)
        feedStrs.insert(feedStr, at: index)
        UserDefaults.feedStrs = feedStrs
    }
    
    static func refreshFeed(at index: Int, completion: (()->Void)? ) {
        if index < AppData.shared.feeds.count && index >= 0 {
            AppData.shared.feeds[index].load(completion: completion)
        }
    }
    
    static func refreshFeeds(completion: (()->Void)? ) {
        for feed in AppData.shared.feeds {
            feed.load(completion: completion)
        }
    }
    

}

class Feed: Equatable {
    
    let url: URL?
    var result: Result?
    var items: [FeedItem]?
    var name: String?
    
    static func == (lhs: Feed, rhs: Feed) -> Bool {
        return lhs.url == rhs.url
    }
    
    init(_ _url: URL?) {
        url = _url
    }
    
    func load(completion: (() -> Void)? ) {
        
        guard let feedURL = url else { return }
        let parser = FeedParser(URL: feedURL)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            
            var _items: [FeedItem] = []
            
            switch result {
                
            case let .atom(feed):
                
                feed.entries?.forEach({ (entry) in
                    guard let urlStr = entry.links?.first?.attributes?.href else { return }
                    let url = URL(string: urlStr)
                    _items.append(FeedItem(title: entry.title ?? "No title", url: url))
                })
                
                self.name = feed.title
                
            case let .rss(feed):
                
                feed.items?.forEach({ (entry) in
                    guard let urlStr = entry.link else { return }
                    let url = URL(string: urlStr)
                    _items.append(FeedItem(title: entry.title ?? "No title", url: url))
                })
                
                self.name = feed.title
                
            case let .json(feed):
                
                feed.items?.forEach({ (entry) in
                    guard let urlStr = entry.url else { return }
                    let url = URL(string: urlStr)
                    _items.append(FeedItem(title: entry.title ?? "No title", url: url))
                })
                
                self.name = feed.title
                
            case .failure(_):
                return
            }
            
            self.items = _items
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}

class FeedItem {
    
    let url: URL?
    let title: String
    
    init(title _title: String, url _url: URL?) {
        title = _title
        url = _url
    }
}
