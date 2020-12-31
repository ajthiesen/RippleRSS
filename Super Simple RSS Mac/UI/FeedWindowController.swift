//
//  FeedWindowController.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa
import FeedKit

class FeedWindowController: NSWindowController {

    var feedWindow: FeedWindow?
    
    override func loadWindow() {
        
        let offsetX = round(Globals.screenVisibleFrame.width / 2) - round(FeedWindow.defaultWidth / 2)
        let offsetY = round(Globals.screenVisibleFrame.height / 2) - round(FeedWindow.defaultHeight / 2)
        
        feedWindow = FeedWindow(
            contentRect: NSRect(x: offsetX, y: offsetY, width: FeedWindow.defaultWidth, height: FeedWindow.defaultHeight),
            styleMask: [.resizable, .closable, .miniaturizable, .titled, .fullSizeContentView ], backing: .buffered, defer: false)
        
        window = feedWindow!
        window?.setFrameAutosaveName(feedWindow!.frameAutosaveName)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }

    @IBAction func deleteSelectedFeed(_ sender: Any) {
        
        feedWindow?.showDeleteFeedSheet()
    }
    
    @IBAction func refreshFeeds(_ sender: Any) {
        
        appDelegate?.refreshFeeds()
    }
}
