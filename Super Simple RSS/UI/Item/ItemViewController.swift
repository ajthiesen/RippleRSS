//
//  ItemViewController.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 1/1/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

    let itemView = ItemView()
    
    override func loadView() {
        view = itemView
        
        itemView.tableView.delegate = self
        
        title = "Feed Name"
        
        #if targetEnvironment(macCatalyst)
        navigationController?.setNavigationBarHidden(true, animated: false)
        #endif
    }
}

extension ItemViewController: UITableViewDelegate {
    
}
