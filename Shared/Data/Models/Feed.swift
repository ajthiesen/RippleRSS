//
//  Feed.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 1/2/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import Foundation
import FeedKit

class Feed: NSObject {
    
    var url: URL
    var items: [FeedItem]?
    var name: String?
    
    init(_ _url: URL) {
        url = _url
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
                }
            
            case .failure(_):
                // TODO: Throw failure
                return
            }
            
            self.items = _items
            
            DispatchQueue.main.async {
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
