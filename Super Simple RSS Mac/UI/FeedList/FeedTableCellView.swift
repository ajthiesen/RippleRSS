//
//  FeedTableCellView.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

class FeedTableCellView: NSTableCellView {

    let leftLabel = NSTextField()
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        leftLabel.isEditable = false
        leftLabel.isSelectable = false
        leftLabel.isBezeled = false
        leftLabel.backgroundColor = .clear
        leftLabel.maximumNumberOfLines = 3
        
        addSubview(leftLabel)
    }
    
    override func layout() {
        
        super.layout()
        
        leftLabel.frame.origin.x = 0
        leftLabel.frame.origin.y = 0
        leftLabel.frame.size.width = bounds.width
        leftLabel.frame.size.height = bounds.height - 8
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
