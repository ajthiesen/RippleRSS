//
//  FeedListViewController.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

fileprivate extension Selector {
    static let copyLink = #selector(ItemListViewController.copyLink(_:))
}

class ItemListViewController: NSViewController {
    
    let itemListView = ItemListView()
    
    var feed: Feed? {
        didSet {
            itemListView.outlineView.reloadData()
        }
    }

    override func loadView() {
        
        view = itemListView
        
        itemListView.outlineView.delegate = self
        itemListView.outlineView.dataSource = self
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier.init("Column") )
        column.title = "Feeds"
        column.isEditable = false
        
        itemListView.outlineView.addTableColumn(column)
        itemListView.outlineView.outlineTableColumn = column
        
        itemListView.outlineView.reloadData()
        
    }
    
    override func rightMouseDown(with event: NSEvent) {
        
        let index = itemListView.outlineView.selectedRow
        let item = itemListView.outlineView.item(atRow: index)
        guard let rowItem = item as? FeedItem else { return }
        
        if index < 0 || index > feed?.items?.count ?? 0 {
            return
        }
        
        let rMenu = NSMenu()
        let linkItem = NSMenuItem(title: "Copy Link", action: .copyLink, keyEquivalent: "")
        linkItem.representedObject = rowItem
        rMenu.addItem(linkItem)
        
        let point = itemListView.convert(event.locationInWindow, from: nil)
        
        rMenu.popUp(positioning: nil, at: point, in: itemListView)
    }
    
    @objc func copyLink(_ sender: NSMenuItem) {
        
        guard let rowItem = sender.representedObject as? FeedItem else { return }
        guard let url = rowItem.url else { return }
        
        print(url.absoluteString)
        
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setData(url.dataRepresentation, forType: .URL)
    }
    
}

extension ItemListViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {

        guard let items = feed?.items else { return 0 }
        
        return items.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {

        guard let items = feed?.items else { return 0 }
        
        return items[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        return false
    }
    
    func outlineViewColumnDidResize(_ notification: Notification) {
        itemListView.outlineView.reloadData()
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        
        guard let item = item as? FeedItem else { return 32 }
        let labelString = item.title
        
        return ItemTableCellView.height(tableViewWidth: itemListView.outlineView.bounds.width, labelString: labelString)
    }
    
    func outlineView(_ outlineView: NSOutlineView, toolTipFor cell: NSCell, rect: NSRectPointer, tableColumn: NSTableColumn?, item: Any, mouseLocation: NSPoint) -> String {
        return "Feed Item"
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        var cell: ItemTableCellView

        if let reuseCell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ItemCell"), owner: self) as? ItemTableCellView {
            cell = reuseCell
        } else {
            cell = ItemTableCellView(frame: .zero)
            cell.identifier = NSUserInterfaceItemIdentifier(rawValue: "ItemCell")
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
            }
        }
    }
    
}
