//
//  FeedListView.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

class FeedListView: NSView {
    
    let outlineScrollView = NSScrollView()
    let outlineView = FeedListOutlineView()
    
    let outlineViewWidth: CGFloat = 200

    override var allowsVibrancy: Bool {
        return true
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        outlineView.backgroundColor = .clear
        outlineView.headerView = nil
        outlineView.selectionHighlightStyle = .sourceList
        
        outlineView.allowsColumnReordering = false
        outlineView.allowsMultipleSelection = false
//        outlineView.indentationPerLevel = 5
//        outlineView.indentationMarkerFollowsCell = true
//        outlineScrollView.backgroundColor = .windowBackgroundColor
        outlineScrollView.backgroundColor = .clear
        outlineScrollView.documentView = outlineView
        outlineScrollView.hasVerticalScroller = true
        outlineScrollView.automaticallyAdjustsContentInsets = false
        outlineScrollView.contentInsets = NSEdgeInsets(top: 10, left: 2, bottom: 10, right: 0)
        outlineScrollView.scrollerInsets = NSEdgeInsets(top: -10, left: 0, bottom: -10, right: 0)
        
        addSubview(outlineScrollView)
    }
    
    override func layout() {
        if #available(OSX 11.0, *) {
            outlineScrollView.frame = bounds.insetBy(dx: safeAreaInsets.left, dy: safeAreaInsets.top)
            outlineScrollView.frame.origin.x = safeAreaInsets.left
            outlineScrollView.frame.origin.y = safeAreaInsets.top
        } else {
            outlineScrollView.frame = bounds
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
