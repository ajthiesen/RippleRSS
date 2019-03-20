//
//  UserDefaults+Feeds.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

fileprivate extension String {
    static let prefix = "com.geofcrowl.SuperSimpleRSS"
    static let feedsKey = .prefix + ".Feeds"
}

extension UserDefaults {
    
    static var feedStrs: [String] {
        
        get {
            
            if let feeds = UserDefaults.standard.stringArray(forKey: .feedsKey) {
                
                return feeds
                
            } else {
                // set to blank String Array
                let blank: [String] = []
                UserDefaults.standard.set(blank, forKey: .feedsKey)
                UserDefaults.standard.synchronize()
                return blank
            }
        }
        
        set {
            
            UserDefaults.standard.set(newValue, forKey: .feedsKey)
            UserDefaults.standard.synchronize()
        }
    }
}

