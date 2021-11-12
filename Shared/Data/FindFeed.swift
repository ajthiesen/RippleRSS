//
//  FindFeed.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 1/2/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import Foundation
import SwiftSoup

class FindFeed {
    
    typealias CompletionHandler = ((_ url: URL) -> Void)
    typealias ErrorHandler = ((_ error: FeedError?) -> Void)
    typealias HtmlStrCompletionHandler = (_ htmlStr: String?) -> Void
    
    enum FeedError: Error {
        case invalidURL
        case missingFeed
        case emptyURL
        case unknown
    }
    
    static func getFeedUrlFromHTML(htmlStr: String, baseURLStr: String) throws -> URL {
        
        let doc: Document = try SwiftSoup.parse(htmlStr)
        
        let elements: Elements? = try doc.head()!.select("link[type=\"application/rss+xml\"")
        
        if elements == nil { throw FeedError.missingFeed }
        
        guard let feedLocation = try elements?.first()?.attr("href") else {
            throw FeedError.missingFeed
        }
        
        var feedURLStr: String
        
        // If the feed is offsite or contains an absolute path
        if !feedLocation.contains("http") {
            feedURLStr = baseURLStr + feedLocation
        } else {
            feedURLStr = feedLocation
        }
        
        guard let url = URL(string: feedURLStr) else { throw FeedError.invalidURL }
        return url
    }
    
    static func getHtml(urlStr: String, completion: @escaping HtmlStrCompletionHandler) throws {
        
        guard let url = URL(string: urlStr) else { throw FeedError.invalidURL }
        
        var htmlStr: String?
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil { return }
            
            if let data = data {
                htmlStr = String(data: data, encoding: String.Encoding.ascii)
                
                completion(htmlStr)
            }
        }
        
        task.resume()
    }
    
    static func findFeedHandler(urlStr: String, onSuccess: @escaping CompletionHandler, onError: @escaping ErrorHandler) {
        
        // TODO: Check URL for validity
        if urlStr.isEmpty {
            onError(FeedError.emptyURL)
            return
        }
        
        // Get base URL for later use
        let siteURL = URL(string: urlStr)!
        let relative = siteURL.relativePath
        let baseURLStr = urlStr.replacingOccurrences(of: relative, with: "")
        
        do {
        
            try FindFeed.getHtml(urlStr: urlStr) { htmlStr in
                
                guard let htmlStr = htmlStr else { return }
                
                do {
                    let feedURL = try FindFeed.getFeedUrlFromHTML(htmlStr: htmlStr, baseURLStr: baseURLStr)
                    print("feedURL:", feedURL)
                    DispatchQueue.main.async {
                        // TODO: Show resolved URL
                        onSuccess(feedURL)
                    }
                    
                } catch FindFeed.FeedError.missingFeed {
                
                    // Didn't find a feed, maybe this is a feed URL?
                    print("AddFeedWindowController: Couldn't find feed; maybe URL is a feed?")
                    DispatchQueue.main.async {
                        // TODO: Show resolved URL
//                        onSuccess(feedURL)
                        onError(.missingFeed)
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        onError(.invalidURL)
                    }
                }
                
            }
            
        } catch {
            DispatchQueue.main.async {
                onError(.unknown)
            }
        }
    }

}
