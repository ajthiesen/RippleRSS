//
//  FeedOutlineView.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

class FeedListOutlineView: NSOutlineView {

    override var allowsVibrancy: Bool {
        return true
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
