//
//  FeedSplitViewController.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa

class FeedSplitViewController: NSSplitViewController {

    let feedListVC = FeedListViewController()
    let itemListVC = ItemListViewController()
    let detailVC = DetailViewController()
    
    override func viewDidLoad() {
        
        let feedListSVI = NSSplitViewItem(sidebarWithViewController: feedListVC)
        feedListSVI.maximumThickness = 400
        feedListSVI.minimumThickness = 200
        addSplitViewItem(feedListSVI)
        
        let itemListSVI = NSSplitViewItem(sidebarWithViewController: itemListVC)
        itemListSVI.maximumThickness = 400
        itemListSVI.minimumThickness = 200
        addSplitViewItem(itemListSVI)
        
        let detailSVI = NSSplitViewItem(viewController: detailVC)
        detailSVI.minimumThickness = 350
        addSplitViewItem(detailSVI)
    }
}
