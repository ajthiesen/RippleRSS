//
//  FeedListView.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

class ItemListView: NSView {
    
    let outlineScrollView = NSScrollView()
    let outlineView = FeedListOutlineView()
    
    let outlineViewWidth: CGFloat = 200

    override var allowsVibrancy: Bool {
        return true
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        outlineView.headerView = nil
        
        outlineView.allowsColumnReordering = false
        outlineView.allowsMultipleSelection = false
        
        outlineScrollView.documentView = outlineView
        outlineScrollView.hasVerticalScroller = true
        
        addSubview(outlineScrollView)
    }
    
    override func layout() {
        if #available(OSX 11.0, *) {
            outlineScrollView.frame.size.width = bounds.width - (safeAreaInsets.left + safeAreaInsets.right)
            outlineScrollView.frame.size.height = bounds.height - (safeAreaInsets.top + safeAreaInsets.bottom)
            outlineScrollView.frame.origin.x = safeAreaInsets.left
            outlineScrollView.frame.origin.y = 0
        } else {
            outlineScrollView.frame = bounds
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
