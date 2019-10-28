//
//  FeedSplitViewController.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit

class FeedSplitViewController: UISplitViewController {
    
    var masterViewController: UIViewController? {
        
        if viewControllers.indices.contains(0) {
            return viewControllers[0]
        }
        return nil
    }
    
    var detailViewController: UIViewController? {
        
        if viewControllers.indices.contains(1) {
            return viewControllers[1]
        }
        return nil
    }
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
        
        preferredDisplayMode = .allVisible
        
        viewControllers = [
            FeedNavigationViewController(rootViewController: FeedViewController()),
        ]
        
        delegate = self
        
        #if targetEnvironment(macCatalyst)
            primaryBackgroundStyle = .sidebar
        #endif
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FeedSplitViewController: UISplitViewControllerDelegate {
    
}

