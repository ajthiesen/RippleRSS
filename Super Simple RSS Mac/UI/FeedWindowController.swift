//
//  FeedWindowController.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa
import FeedKit

fileprivate extension Selector {
    static let handleRefreshFeeds = #selector(FeedWindowController.refreshFeeds(_:))
    static let handleNewFeed = #selector(FeedWindowController.newFeed(_:))
    
    static let handlePrevFeed = #selector(FeedWindowController.prevFeed(_:))
    static let handleNextFeed = #selector(FeedWindowController.nextFeed(_:))
    
    static let handlePrevItem = #selector(FeedWindowController.prevItem(_:))
    static let handleNextItem = #selector(FeedWindowController.nextItem(_:))
}

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
    
    @objc func newFeed(_ sender: Any) {
        
        guard let window = window else { return }
        appDelegate?.showAddFeedWindow(window)
    }
    
    @objc func prevFeed(_ sender: Any) {
        feedWindow?.feedSplitVC.feedListVC.moveToNextFeed(reverse: true)
    }
    
    @objc func nextFeed(_ sender: Any) {
        feedWindow?.feedSplitVC.feedListVC.moveToNextFeed()
    }
    
    @objc func prevItem(_ sender: Any) {
        feedWindow?.feedSplitVC.itemListVC.moveToNextItem(reverse: true)
    }
    
    @objc func nextItem(_ sender: Any) {
        feedWindow?.feedSplitVC.itemListVC.moveToNextItem()
    }
}

// MARK: - NSTouchBarDelegate

private extension NSTouchBar.CustomizationIdentifier {
    static let touchBar = "com.geofcrowl.Super-Simple-RSS-Mac.touchBar"
}

extension NSTouchBarItem.Identifier {
    static let refreshFeeds = NSTouchBarItem.Identifier("com.geofcrowl.Super-Simple-RSS-Mac.refreshFeeds")
    static let newFeed = NSTouchBarItem.Identifier("com.geofcrowl.Super-Simple-RSS-Mac.newFeed")
    static let prevFeed = NSTouchBarItem.Identifier("com.geofcrowl.Super-Simple-RSS-Mac.prevFeed")
    static let nextFeed = NSTouchBarItem.Identifier("com.geofcrowl.Super-Simple-RSS-Mac.nextFeed")
    static let prevItem = NSTouchBarItem.Identifier("com.geofcrowl.Super-Simple-RSS-Mac.prevItem")
    static let nextItem = NSTouchBarItem.Identifier("com.geofcrowl.Super-Simple-RSS-Mac.nextItem")
}

extension FeedWindowController: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        let touchbar = NSTouchBar()
        touchbar.delegate = self
        touchbar.customizationIdentifier = .touchBar
        touchbar.defaultItemIdentifiers = [
            .refreshFeeds,
            .newFeed,
            .fixedSpaceSmall,
            .prevFeed,
            .nextFeed,
            .fixedSpaceSmall,
            .prevItem,
            .nextItem,
        ]
        
        return touchbar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        switch identifier {
        
        case .refreshFeeds:
            
            let item = NSCustomTouchBarItem(identifier: .refreshFeeds)
            
            item.view = createToolBarButton(title: "Refresh Feeds", systemSymbolName: "arrow.clockwise", fallbackImageName: nil, target: self, action: .handleRefreshFeeds)
            
            return item
            
        case .newFeed:
            
            let item = NSCustomTouchBarItem(identifier: .newFeed)
            
            item.view = createToolBarButton(title: "New Feed", systemSymbolName: "plus", fallbackImageName: "ico-toolbar-plus", target: self, action: .handleNewFeed)
            
            return item
            
        case .prevFeed:
            
            let item = NSCustomTouchBarItem(identifier: .prevFeed)
            
            item.view = createToolBarButton(title: "Feed", systemSymbolName: "chevron.left.2", fallbackImageName: nil, target: self, action: .handlePrevFeed)
            
            return item
            
        case .nextFeed:
            
            let item = NSCustomTouchBarItem(identifier: .nextFeed)
            
            item.view = createToolBarButton(title: "Feed", systemSymbolName: "chevron.right.2", fallbackImageName: nil, target: self, action: .handleNextFeed)
            
            return item
            
        case .prevItem:
            
            let item = NSCustomTouchBarItem(identifier: .prevItem)
            
            item.view = createToolBarButton(title: "Item", systemSymbolName: "chevron.left", fallbackImageName: nil, target: self, action: .handlePrevItem)
            
            return item
            
        case .nextItem:
            
            let item = NSCustomTouchBarItem(identifier: .nextItem)
            
            item.view = createToolBarButton(title: "Item", systemSymbolName: "chevron.right", fallbackImageName: nil, target: self, action: .handleNextItem)
            
            return item
            
        default:
            return nil
        }
    }
    
    func createToolBarButton(title: String, systemSymbolName: String, fallbackImageName: String?, target: Any?, action: Selector?) -> NSButton {
        
        var image = NSImage()
        
        if #available(OSX 11.0, *) {
            image = NSImage(systemSymbolName: systemSymbolName, accessibilityDescription: title)!
        } else if let fallbackImageName = fallbackImageName {
            image = NSImage(named: fallbackImageName)!
        }
        
        return NSButton(title: title, image: image, target: target, action: action)
    }

}
