//
//  FeedListViewController.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

fileprivate extension Selector {
    static let deleteItem = #selector(FeedListViewController.deleteItem(sender:))
}

class ItemListViewController: NSViewController {
    
    let feedListView = ItemListView()
    
    var feed: Feed? {
        didSet {
            feedListView.outlineView.reloadData()
        }
    }

    override func loadView() {
        
        view = feedListView
        
        feedListView.outlineView.delegate = self
        feedListView.outlineView.dataSource = self
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier.init("Column") )
        column.title = "Feeds"
        column.isEditable = false
        
        feedListView.outlineView.addTableColumn(column)
        feedListView.outlineView.outlineTableColumn = column
        
        feedListView.outlineView.reloadData()
    }
    
    @objc func deleteItem(sender: Any) {
        
    }
    
}

extension ItemListViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
//        if let feed = item as? Feed {
//            guard let items = feed.items else { return 0 }
//            return items.count
//        }
        guard let items = feed?.items else { return 0 }
        
        return items.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
//        if let feed = item as? Feed {
//            guard let items = feed.items else { return FeedItem(title: "N/A", url: nil) }
//            return items[index]
//        }
        guard let items = feed?.items else { return 0 }
        
        return items[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        
        if let _ = item as? Feed {
            return 32
        }
        
        return 48
    }
    
    func outlineView(_ outlineView: NSOutlineView, toolTipFor cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, item: Any, mouseLocation: NSPoint) -> String {
        return "Feed Item"
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        var cell: FeedTableCellView

        if let reuseCell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedCell"), owner: self) as? FeedTableCellView {
            cell = reuseCell
        } else {
            cell = FeedTableCellView(frame: .zero)
            cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "FeedCell")
        }

        if let feed = item as? Feed {
            cell.leftLabel.stringValue = feed.name ?? feed.url?.absoluteString ?? "N/A"
            cell.objectValue = feed
        }
        
        if let feedItem = item as? FeedItem {
            cell.leftLabel.stringValue = feedItem.title
            cell.objectValue = feedItem
        }
        
        return cell
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        
        let selectedRow = outlineView.selectedRow
        print(selectedRow)
        
        if let feedItem = outlineView.item(atRow: selectedRow) as? FeedItem {
            
            if let url = feedItem.url {
                appDelegate?.showPostDetail(url: url)
//                self.webView.mainFrame.load(URLRequest(url: url))
            }
        }
        
        
//        if let feedItem = outlineView.item(atRow: selectedIndex) as? FeedItem {
//
//            let url = URL(string: feedItem.url)
//
//            if let url = url {
//
//                self.webView.mainFrame.load(URLRequest(url: url))
//            }
//        }
    }
    
}
