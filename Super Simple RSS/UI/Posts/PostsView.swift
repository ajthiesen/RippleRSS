//
//  PostsView.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit

class PostsView: UIView {
    
    var tableView = UITableView()

    init() {
        
        super.init(frame: .zero)
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        addSubview(tableView)
    }
    
    override func layoutSubviews() {
        tableView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
