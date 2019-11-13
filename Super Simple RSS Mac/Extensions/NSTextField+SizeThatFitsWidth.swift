//
//  NSTextField+SizeThatFitsWidth.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 11/12/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

extension NSTextField {
    
    func size(thatFitsWidth labelWidth: CGFloat, multiline: Bool) -> CGSize {
        
        guard let labelFont = self.font else { return CGSize.zero }
        let labelText = self.stringValue
        
        let textLabelHeight = labelText.height(fitsWidth: labelWidth, font: labelFont, multiline: multiline)
        
        return CGSize(width: labelWidth, height: textLabelHeight)
    }
    
}
