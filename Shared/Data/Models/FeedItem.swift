//
//  FeedItem.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 1/2/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import Foundation

class FeedItem: NSObject, ObservableObject {
    
    static func == (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.url == rhs.url
    }
    
    let url: URL?
    let title: String
    var content: String?
    var pubDate: Date?
    
    init(title _title: String, url _url: URL?) {
        title = _title
        url = _url
    }
}
