//
//  ItemView.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 1/1/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import UIKit

class ItemView: UIView {

    let tableView = UITableView(frame: .zero, style: .plain)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
}
