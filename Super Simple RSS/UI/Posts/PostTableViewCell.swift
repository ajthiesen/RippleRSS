//
//  PostTableViewCell.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return "PostCell"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.numberOfLines = 0
        
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
