//
//  RefreshFeedsToolbarItem.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/20/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

class RefreshFeedsToolbarItem: NSToolbarItem {

    var button: NSButton
    var icon: NSImage
    
    static var itemIdentifier: NSToolbarItem.Identifier {
        return .refreshFeeds
    }
    
    init() {
        button = NSButton(frame: NSRect(x: 0, y: 0, width: 32, height: 32))
        icon = NSImage(imageLiteralResourceName: "ico-toolbar-refresh")
        
        super.init(itemIdentifier: RefreshFeedsToolbarItem.itemIdentifier)
        label = "Refresh Feeds"
        paletteLabel = "Refresh Feeds"
        toolTip = "Refresh Feeds"
        isEnabled = true
        
        button.bezelStyle = .texturedRounded
        button.stringValue = ""
        button.image = icon
        button.sizeToFit()
        button.frame.size.width = 32
        
        view = button
    }
    
}
