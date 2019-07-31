//
//  AddFeedWindowController.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/20/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

class AddFeedWindowController: NSWindowController {
    
    var hostWindow: NSWindow?
    
    @IBOutlet var feedUrlTextField: NSTextField!
    
    convenience init() {

        self.init(windowNibName: NSNib.Name("AddFeedSheet"))
    }

    func runSheetOnWindow(_ _hostWindow: NSWindow) {
        
        hostWindow = _hostWindow
        
        hostWindow!.beginSheet(window!) { [unowned self] (returnCode: NSApplication.ModalResponse) in
            
            if returnCode == NSApplication.ModalResponse.OK {
                self.addFeed()
            }
        }
    }
    
    func addFeed() {
        
        let feedUrlStr = feedUrlTextField.stringValue
        
        if feedUrlStr.isEmpty {
            return
        }
        
        AppData.addFeed(feedUrlStr)
        appDelegate?.refreshFeeds()
    }
    
    @IBAction func cancel(_ sender: Any) {
        hostWindow!.endSheet(window!, returnCode: NSApplication.ModalResponse.cancel)
    }
    
    @IBAction func addFeed(_ sender: Any) {
        hostWindow!.endSheet(window!, returnCode: NSApplication.ModalResponse.OK)
    }

}
