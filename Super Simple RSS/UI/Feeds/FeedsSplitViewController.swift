//
//  FeedSplitViewController.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit

class FeedsSplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        #if targetEnvironment(macCatalyst)
        primaryBackgroundStyle = .sidebar
        #endif
        
        preferredDisplayMode = .twoBesideSecondary
        
        setViewController(FeedsViewController(), for: .primary)
        setViewController(PostsViewController(), for: .supplementary)
    }
    
}
