//
//  AppData.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit
import FeedKit

class AppData {

    static let shared = AppData()
    
    var feedURLs: [URL?]
    
    private init() {
        
        feedURLs = []
        
        // add URLs from UserDefaults
        for feedStr in UserDefaults.feedStrs {
            
            guard let url = URL(string: feedStr) else { continue }
            feedURLs.append(url)
        }
    }
    
    static func addFeed(_ feedStr: String) {
        
        guard let url = URL(string: feedStr) else { return }
        
        AppData.shared.feedURLs.append(url)
        UserDefaults.feedStrs.append(feedStr)
    }
    
    static func deleteFeed(at index: Int) {
        
        AppData.shared.feedURLs.remove(at: index)
        
        var feedStrs = UserDefaults.feedStrs
        feedStrs.remove(at: index)
        UserDefaults.feedStrs = feedStrs
    }
}
