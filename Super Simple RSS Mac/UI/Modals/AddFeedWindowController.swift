//
//  AddFeedWindowController.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/20/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa
import SwiftSoup

class AddFeedWindowController: NSWindowController {
    
    typealias CompletionHandler = (() -> Void)
    
    var hostWindow: NSWindow?
    
    @IBOutlet var feedUrlTextField: NSTextField!
    @IBOutlet var activityIndicator: NSProgressIndicator!
    @IBOutlet var errorTextField: NSTextField!
    
    convenience init() {

        self.init(windowNibName: NSNib.Name("AddFeedSheet"))
    }

    func runSheetOnWindow(_ _hostWindow: NSWindow) {
        
        hostWindow = _hostWindow
        
        hostWindow!.beginSheet(window!) { [unowned self] (returnCode: NSApplication.ModalResponse) in
            
            if returnCode == NSApplication.ModalResponse.OK {
                self.addFeed()
            }
        }
        
        feedUrlTextField.stringValue = "http://www."
    }
    
    func findFeed(onSuccess: @escaping CompletionHandler, onError: @escaping CompletionHandler) {
            
        let siteURLString = feedUrlTextField.stringValue
        let siteURL = URL(string: siteURLString)!
        
        let relative = siteURL.relativePath
        let baseURLStr = siteURLString.replacingOccurrences(of: relative, with: "")
        
        // TODO: Check URL for validity
        if siteURLString.isEmpty {
            return
        }
        
        // TODO: Check if URL is actually a feed URL

        var feedURL: URL?
        
        do {
        
            try FindFeed.getHtml(urlStr: siteURLString) { htmlStr in
                
                guard let htmlStr = htmlStr else { return }
                
                do {
                    feedURL = try FindFeed.getFeedUrlFromHTML(htmlStr: htmlStr, baseURLStr: baseURLStr)
                    
                    DispatchQueue.main.async {
                        self.feedUrlTextField.stringValue = feedURL?.absoluteString ?? siteURLString
                        onSuccess()
                    }
                    
                } catch FindFeed.FeedError.missingFeed {
                
                    // Didn't find a feed, maybe this is a feed URL?
                    print("AddFeedWindowController: Couldn't find feed; maybe URL is a feed?")
                    DispatchQueue.main.async {
                        self.feedUrlTextField.stringValue = siteURLString
                        onSuccess()
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        onError()
                    }
                }
                
            }
            
        } catch {
            DispatchQueue.main.async {
                onError()
            }
        }
    }
    
    func addFeed() {
        
        let feedURLString = feedUrlTextField.stringValue
        
        // TODO: Check URL for validity
        if feedURLString.isEmpty {
            return
        }
        
        AppData.addFeed(feedURLString)
        appDelegate?.refreshFeeds()
    }
    
    @IBAction func cancel(_ sender: Any) {
        hostWindow!.endSheet(window!, returnCode: NSApplication.ModalResponse.cancel)
    }
    
    @IBAction func addFeed(_ sender: Any) {
        
        errorTextField.isHidden = true
        activityIndicator.startAnimation(self)
        
        findFeed(onSuccess: {
            
            self.activityIndicator.stopAnimation(self)
            self.hostWindow!.endSheet(self.window!, returnCode: NSApplication.ModalResponse.OK)
            
        }, onError: {
            
            self.activityIndicator.stopAnimation(self)
            self.errorTextField.isHidden = false
            self.errorTextField.stringValue = "Could not find a feed at this URL"
        })
        
        
    }

}

//class FindFeed {
//
//    typealias HtmlStrCompletionHandler = (_ htmlStr: String?) -> Void
//
//    enum FeedError: Error {
//        case invalidURL
//        case missingFeed
//    }
//
//    static func getFeedUrl(htmlStr: String, baseURLStr: String) throws -> URL? {
//
//        let doc: Document = try SwiftSoup.parse(htmlStr)
//
//        let elements: Elements? = try doc.head()!.select("link[type=\"application/rss+xml\"")
//
//        if elements == nil { throw FeedError.missingFeed }
//
//        guard let feedLocation = try elements?.first()?.attr("href") else {
//            throw FeedError.missingFeed
//        }
//
//        var feedURLStr: String
//
//        // If the feed is offsite or contains an absolute path
//        if !feedLocation.contains("http") {
//            feedURLStr = baseURLStr + feedLocation
//        } else {
//            feedURLStr = feedLocation
//        }
//
//        return URL(string: feedURLStr)
//    }
//
//    static func getHtml(urlStr: String, completion: @escaping HtmlStrCompletionHandler) throws {
//
//        guard let url = URL(string: urlStr) else { throw FeedError.invalidURL }
//
//        var htmlStr: String?
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//
//            if error != nil { return }
//
//            if let data = data {
//                htmlStr = String(data: data, encoding: String.Encoding.ascii)
//
//                completion(htmlStr)
//            }
//        }
//
//        task.resume()
//    }
//}
