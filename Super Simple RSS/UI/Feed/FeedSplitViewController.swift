//
//  FeedSplitViewController.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit

class FeedSplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        #if targetEnvironment(macCatalyst)
        primaryBackgroundStyle = .sidebar
        #endif
        
        preferredDisplayMode = .twoBesideSecondary
        
        setViewController(FeedViewController(), for: .primary)
        setViewController(ItemViewController(), for: .supplementary)
    }
    
}
