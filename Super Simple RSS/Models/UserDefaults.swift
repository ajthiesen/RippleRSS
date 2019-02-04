//
//  UserSettings.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit

fileprivate extension String {
    static let prefix = "com.geofcrowl.SuperSimpleRSS"
    static let feedsKey = .prefix + ".Feeds"
}

extension UserDefaults {

    static var feeds: [String] {
        
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
