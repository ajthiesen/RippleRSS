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
    
    var feedURLs: [URL?] = []
    
    lazy var parsers: [FeedParser]? = {
        
        var parsers = [FeedParser]()
        for url in feedURLs {
            
            guard let url = url else { continue }
            parsers.append(FeedParser(URL: url))
        }
        
        return parsers
    }()
    
    var parsedFeeds: [Any?]?
    
    private init() {
        
        // add URLs from UserDefaults
//        for 
    }
}
