//
//  NSString+Height.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 11/12/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

extension NSString {
    
    func height(fitsWidth width: CGFloat, font: NSFont, multiline: Bool = true) -> CGFloat {
        
        let size = CGSize(width: width, height: .infinity)
        let opts: NSString.DrawingOptions = multiline ? [.usesLineFragmentOrigin] : []
        let attrs = [NSAttributedString.Key.font: font]
        
        return self.boundingRect(with: size, options: opts, attributes: attrs, context: nil).height
    }
}
