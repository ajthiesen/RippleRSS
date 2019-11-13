//
//  FeedTableCellView.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

class ItemTableCellView: NSTableCellView {

    let leftLabel = NSTextField()
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        
        leftLabel.isEditable = false
        leftLabel.isSelectable = false
        leftLabel.isBezeled = false
        leftLabel.backgroundColor = .clear
        leftLabel.maximumNumberOfLines = 0
        
        addSubview(leftLabel)
    }
    
    override func layout() {
        
        super.layout()
        
        leftLabel.frame.origin.x = 0
        leftLabel.frame.origin.y = 0
        leftLabel.frame.size.width = bounds.width
        leftLabel.frame.size.height = bounds.height - 8
        
//        leftLabel.frame.size = leftLabel.size(thatFitsWidth: bounds.width, multiline: true)
    }
    
    static func height(tableViewWidth: CGFloat, labelString: String) -> CGFloat {
        
        let verticalMargin: CGFloat = 16
        let textWidth: CGFloat = tableViewWidth - 16
        
        let textLabelString = NSString(string: labelString)
        
        let labelFont = NSFont.systemFont(ofSize: 13)
        
        let textLabelHeight = textLabelString.height(fitsWidth: textWidth, font: labelFont, multiline: true)
        
        let combinedHeight = textLabelHeight + verticalMargin
        
        return combinedHeight
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
