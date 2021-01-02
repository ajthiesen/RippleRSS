//
//  Feed.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 1/2/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import UIKit
import FeedKit

class Feed: NSObject {
    
    let url: URL?
    var items: [FeedItem]?
    var name: String?
    
    static func == (lhs: Feed, rhs: Feed) -> Bool {
        return lhs.url == rhs.url && lhs.name == rhs.name
    }
    
    override var hash: Int {
        
        guard let url = url else { return 0 }
        
        if let name = name {
            return url.absoluteString.hash | name.hash
        }
        
        return url.absoluteString.hash
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
