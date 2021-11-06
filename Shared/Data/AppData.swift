//
//  AppData.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Foundation
import FeedKit
import SwiftUI

class AppData: ObservableObject {
    
    static var shared = AppData()
    
    @Published var feedURLs: [URL?]
    @Published var feeds: [Feed] = []
    
    private init() {
        
        feedURLs = []
        
        // add URLs from UserDefaults
        for feedStr in UserDefaults.feedStrs {
            
            guard let url = URL(string: feedStr) else { continue }
            
            self.feedURLs.append(url)
            self.feeds.append(Feed(url))
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
    
    static func refreshFeed(_ feed: Feed, completion: (()->Void)? ) {
        feed.load(completion: completion)
    }
    
    static func refreshFeeds(rowCompletion: (()->Void)? ) {
        for feed in AppData.shared.feeds {
            feed.load(completion: rowCompletion)
        }
    }
    
    static func addToPasteboard(_ url: URL?) {
        
        guard let url = url else { return }
        
        #if os(macOS)
        
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setData(url.dataRepresentation, forType: .string)
        NSPasteboard.general.setData(url.dataRepresentation, forType: .URL)
        
        #elseif os(iOS)
        
        UIPasteboard.general.string = url.absoluteString
        UIPasteboard.general.url = url
        
        #endif
    }
    
    static func openURL(_ url: URL?) {
        
        guard let url = url else { return }
        
        #if os(macOS)
        
        NSWorkspace.shared.open(url)
        
        #elseif os(iOS)
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
        #endif
    }

}
