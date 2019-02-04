//
//  FeedView.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit

class FeedView: UIView {
    
    let tableView = UITableView()

    init() {
        
        super.init(frame: .zero)
        
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)    // blank if empty dataset
        
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        tableView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
