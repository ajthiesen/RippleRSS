//
//  NewFeedToolbarItem.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

class NewFeedToolbarItem: NSToolbarItem {

    var button: NSButton
    var icon: NSImage
    
    static var itemIdentifier: NSToolbarItem.Identifier {
        return .newFeed
    }
    
    init() {
        
        button = NSButton(frame: NSRect(x: 0, y: 0, width: 32, height: 32))
        
        if #available(OSX 11.0, *) {
            icon = NSImage(systemSymbolName: "plus", accessibilityDescription: "Add New Feed")!
        } else {
            icon = NSImage(imageLiteralResourceName: "ico-toolbar-plus")
        }
        
        super.init(itemIdentifier: NewFeedToolbarItem.itemIdentifier)
        label = "New Feed"
        paletteLabel = "Add a new feed"
        toolTip = "Add a new feed"
        isEnabled = true
        
        button.bezelStyle = .texturedRounded
        button.stringValue = ""
        button.image = icon
        button.sizeToFit()
        button.frame.size.width = 32
        
        view = button
    }
}
