//
//  FeedItem.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 1/2/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import Foundation
import FeedKit

class FeedItem: NSObject, ObservableObject, Comparable {
    
    static func < (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.pubDate ?? Date.distantPast > rhs.pubDate ?? Date.distantPast
    }
    
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.url == rhs.url
    }
    
    var url: URL? {
        guard let parsedItem = parsedItem else { return nil }
        
        if let rssItem = parsedItem as? RSSFeedItem {
            guard let link = rssItem.link else { return nil }
            return URL(string: link)
        } else if let atomItem = parsedItem as? AtomFeedEntry {
            guard let link = atomItem.links?.first?.attributes?.href else { return nil }
            return URL(string: link)
        } else if let jsonItem = parsedItem as? JSONFeedItem {
            guard let link = jsonItem.url else { return nil }
            return URL(string: link)
        }
        return nil
    }
    
    var title: String? {
        guard let parsedItem = parsedItem else { return nil }
        
        if let rssItem = parsedItem as? RSSFeedItem {
            return rssItem.title
        } else if let atomItem = parsedItem as? AtomFeedEntry {
            return atomItem.title
        } else if let jsonItem = parsedItem as? JSONFeedItem {
            return jsonItem.title
        }
        return nil
    }
    
    var summary: String? {
        guard let parsedItem = parsedItem else { return nil }
        
        if let rssItem = parsedItem as? RSSFeedItem {
            return rssItem.description
        } else if let atomItem = parsedItem as? AtomFeedEntry {
            return atomItem.summary?.value
        } else if let jsonItem = parsedItem as? JSONFeedItem {
            return jsonItem.summary
        }
        return nil
    }
    
    var pubDate: Date? {
        guard let parsedItem = parsedItem else { return nil }
        
        if let rssItem = parsedItem as? RSSFeedItem {
            return rssItem.pubDate
        } else if let atomItem = parsedItem as? AtomFeedEntry {
            return atomItem.published
        } else if let jsonItem = parsedItem as? JSONFeedItem {
            return jsonItem.datePublished
        }
        return nil
    }
    
    private var parsedItem: Any?
    
    init(parsedItem _parsedItem: Any?) {
        parsedItem = _parsedItem
    }
}
