//
//  Feed.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 1/2/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import Foundation
import FeedKit
import SwiftUI

class Feed: NSObject, ObservableObject {
    
    @Published var url: URL
    @Published var items: [FeedItem]?
    @Published var name: String
    
    init(_ _url: URL) {
        url = _url
        name = _url.absoluteString
    }
    
    func handle(_ entry: AtomFeedEntry) -> FeedItem? {
        guard let urlStr = entry.links?.first?.attributes?.href else { return nil }
        let url = URL(string: urlStr)
        let feedItem = FeedItem(title: entry.title ?? "No title", url: url)
        feedItem.content = entry.summary?.value
        
        return feedItem
    }
    
    func handle(_ entry: RSSFeedItem) -> FeedItem? {
        guard let urlStr = entry.link else { return nil }
        let url = URL(string: urlStr)
        let feedItem = FeedItem(title: entry.title ?? "No title", url: url)
        feedItem.content = entry.description
        
        return feedItem
    }
    
    func handle(_ entry: JSONFeedItem) -> FeedItem? {
        guard let urlStr = entry.url else { return nil }
        let url = URL(string: urlStr)
        let feedItem = FeedItem(title: entry.title ?? "No title", url: url)
        feedItem.content = entry.contentText
        
        return feedItem
    }
    
    func load(completion: (() -> Void)? ) {
        
        let parser = FeedParser(URL: url)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            
            var _items: [FeedItem] = []
            
            switch result {
            
            case .success(let feed):
                
                switch feed {
                
                case let .atom(feed):
                    
                    feed.entries?.forEach({ (entry) in
                        
                        guard let feedItem = self.handle(entry) else { return }
                        _items.append(feedItem)
                    })
                    
                    DispatchQueue.main.async {
                        if let title = feed.title {
                            self.name = title
                            print(title)
                        }
                    }
                    
                case let .rss(feed):
                    
                    feed.items?.forEach({ (entry) in
                        
                        guard let feedItem = self.handle(entry) else { return }
                        _items.append(feedItem)
                    })
                    
                    DispatchQueue.main.async {
                        if let title = feed.title {
                            self.name = title
                            print(title)
                        }
                    }
                    
                case let .json(feed):
                    
                    feed.items?.forEach({ (entry) in
                        
                        guard let feedItem = self.handle(entry) else { return }
                        _items.append(feedItem)
                    })
                    
                    DispatchQueue.main.async {
                        if let title = feed.title {
                            self.name = title
                            print(title)
                        }
                    }
                    
                }
            
            case .failure(_):
                // TODO: Throw failure
                return
            }
            
            DispatchQueue.main.async {
                self.items = _items
                completion?()
            }
        }
    }
}

extension Feed {
    struct Diffable: Hashable {
        
        static func == (lhs: Feed.Diffable, rhs: Feed.Diffable) -> Bool {
            return lhs.name == rhs.name && lhs.url == rhs.url
        }
        
        var name: String?
        var url: URL
        var feed: Feed
        
        init(feed: Feed) {
            self.feed = feed
            self.url = feed.url
            self.name = feed.name
        }
    }
}
