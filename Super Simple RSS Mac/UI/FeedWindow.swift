//
//  FeedWindow.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

fileprivate extension Selector {
    static let didClickToggleSidebar = #selector(FeedWindow.didClickToggleSidebar(sender:))
    static let didClickNewFeed = #selector(FeedWindow.didClickNewFeed(sender:))
    static let didClickRefreshFeeds = #selector(FeedWindow.didClickRefreshFeeds(sender:))
}

class FeedWindow: NSWindow {
    
    let feedSplitVC = FeedSplitViewController()
    let feedToolbar = NSToolbar(identifier: NSToolbar.Identifier("FeedToolbar"))
    var deleteFeedSheet: DeleteFeedSheetWindowController?
    
    static var defaultWidth: CGFloat {
        return 800
    }
    static var defaultHeight: CGFloat {
        return 540
    }
    
    override var frameAutosaveName: NSWindow.FrameAutosaveName {
        return NSWindow.FrameAutosaveName("com.geofcrowl.SuperSimpleRSS.FeedWindow")
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        delegate = self
        
        autorecalculatesKeyViewLoop = true
        
        title = "Color Catalogue"
        titleVisibility = .hidden
        
        contentViewController = feedSplitVC
        
        toolbar = feedToolbar
        
        feedToolbar.delegate = self
        
        feedToolbar.sizeMode = .regular
        feedToolbar.displayMode = .iconAndLabel
        
        feedToolbar.insertItem(withItemIdentifier: .toggleSidebar, at: 0)
        feedToolbar.insertItem(withItemIdentifier: .refreshFeeds, at: 1)
        feedToolbar.insertItem(withItemIdentifier: .flexibleSpace, at: 2)
        feedToolbar.insertItem(withItemIdentifier: .newFeed, at: 3)
    }
    
    func showDeleteFeedSheet() {
        
        let selectedFeedRow = feedSplitVC.feedListVC.feedListView.outlineView.selectedRow
        
        deleteFeedSheet = DeleteFeedSheetWindowController(feed: AppData.shared.feeds[selectedFeedRow])
        deleteFeedSheet?.runSheetOnWindow(self)
    }

}

// MARK: NSWindowDelegate

extension FeedWindow: NSWindowDelegate {
    func windowDidBecomeMain(_ notification: Notification) {
        // did become main
    }
    
    func windowDidResize(_ notification: Notification) {
        //        layoutWindow()
    }
}

// MARK: NSToolbarItem Actions

extension FeedWindow {
    
    @objc func didClickToggleSidebar(sender: NSToolbarItem) {
        feedSplitVC.toggleSidebar(self)
    }
    
    @objc func didClickNewFeed(sender: NSToolbarItem) {
        appDelegate?.showAddFeedWindow(self)
    }
    
    @objc func didClickRefreshFeeds(sender: NSToolbarItem) {
        appDelegate?.refreshFeeds()
    }
    
}

// MARK: NSToolbarDelegate

extension FeedWindow: NSToolbarDelegate {
    
    // optional delegate function for built in toolbar items
    func toolbarWillAddItem(_ notification: Notification) {
        
        let userInfo = notification.userInfo!
        
        guard let addedItem = userInfo["item"] as? NSToolbarItem else {
            return
        }
        
        let itemIdentifier = addedItem.itemIdentifier
        addedItem.isEnabled = true
        
        if itemIdentifier == .toggleSidebar {
            
            addedItem.target = self
            addedItem.action = .didClickToggleSidebar
            
        } else if itemIdentifier == .refreshFeeds {
            
            addedItem.target = self
            addedItem.action = .didClickRefreshFeeds
            
        } else if itemIdentifier == .newFeed {
            
            addedItem.target = self
            addedItem.action = .didClickNewFeed
        }
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem?
        
        if itemIdentifier == .refreshFeeds {
            
            toolbarItem = RefreshFeedsToolbarItem()
        }
        
        if itemIdentifier == .newFeed {
            
            toolbarItem = NewFeedToolbarItem()
        }
        
        return toolbarItem
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toggleSidebar,
            .refreshFeeds,
            .flexibleSpace,
            .newFeed,
        ]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toggleSidebar,
            .refreshFeeds,
            .flexibleSpace,
            .newFeed,
        ]
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toggleSidebar,
            .refreshFeeds,
            .flexibleSpace,
            .newFeed,
        ]
    }
    
}
