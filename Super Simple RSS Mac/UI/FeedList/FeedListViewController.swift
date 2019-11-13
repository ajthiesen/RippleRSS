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

class FeedListViewController: NSViewController {
    
    let feedListView = FeedListView()
    
    fileprivate var feeds: [Feed] {
        return AppData.shared.feeds
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

extension FeedListViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        return feeds.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        return feeds[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        
        return 32
    }
    
    func outlineView(_ outlineView: NSOutlineView, toolTipFor cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, item: Any, mouseLocation: NSPoint) -> String {
        return "Feed"
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
        
        return cell
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }
        
        let selectedRow = outlineView.selectedRow
        print(selectedRow)
        
        if let feed = outlineView.item(atRow: selectedRow) as? Feed {
            appDelegate?.showFeed(feed: feed)
        }
    }
    
}
