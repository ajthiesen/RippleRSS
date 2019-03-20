//
//  Globals.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

struct Globals {
    
    static var screenVisibleFrame: CGRect {
        get {
            if let screen = NSScreen.main {
                return screen.visibleFrame
            } else {
                return CGRect(x: 0, y: 0, width: 0, height: 0)
            }
        }
    }
    
    static var screenScale: CGFloat {
        return NSScreen.main?.backingScaleFactor ?? 1
    }
}

