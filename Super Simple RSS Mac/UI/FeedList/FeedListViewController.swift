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
    static let copyFeedLink = #selector(FeedListViewController.copyFeedLink(_:))
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
    
    override func rightMouseDown(with event: NSEvent) {
        
        let index = feedListView.outlineView.selectedRow
        let item = feedListView.outlineView.item(atRow: index)
        guard let rowItem = item as? Feed else { return }
        
        if index < 0 || index > feeds.count {
            return
        }
        
        let rMenu = NSMenu()
        let linkItem = NSMenuItem(title: "Copy Feed URL", action: .copyFeedLink, keyEquivalent: "")
        linkItem.representedObject = rowItem
        rMenu.addItem(linkItem)
        
        let point = feedListView.convert(event.locationInWindow, from: nil)
        
        rMenu.popUp(positioning: nil, at: point, in: feedListView)
    }
    
    func moveToNextFeed(reverse: Bool = false) {
        
        var selected = feedListView.outlineView.selectedRow
        if selected == -1 {
            // If there's no selection, selectedRow will return -1
            selected = 0
        } else {
            selected = reverse ? selected - 1 : selected + 1
        }
        
        if selected == feeds.count {
            selected = feeds.count - 1
        }
        
        feedListView.outlineView.selectRowIndexes(IndexSet(integer: selected), byExtendingSelection: false)
        feedListView.outlineView.scrollRowToVisible(selected)
    }
    
    @objc func copyFeedLink(_ sender: NSMenuItem) {
        guard let rowItem = sender.representedObject as? Feed else { return }
        
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(rowItem.url.absoluteString, forType: .string)
        NSPasteboard.general.setData(rowItem.url.dataRepresentation, forType: .URL)
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
            cell.leftLabel.stringValue = feed.name
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
