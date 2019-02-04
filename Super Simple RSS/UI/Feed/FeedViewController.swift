//
//  ViewController.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit
import FeedKit

fileprivate extension Selector {
    static let addFeedItem = #selector(FeedViewController.addFeedItem)
}

class FeedViewController: UIViewController {
    
    let feedView = FeedView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "Feeds"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .addFeedItem)
    }
    
    override func loadView() {
        
        view = feedView
        
        feedView.tableView.dataSource = self
        feedView.tableView.delegate = self
    }
    
    @objc func addFeedItem() {
        
        let alert = UIAlertController(title: "Add A Feed", message: "Feed URL?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "http://geofcrowl.com/blog/feed/"
            textField.returnKeyType = .done
//            textField.delegate = self
        }
        
        alert.addAction(UIAlertAction(title: "Add Feed", style: .default, handler: { [weak self] (action) in
            
            guard let strongSelf = self else { return }
            guard let textFields = alert.textFields else { return }
            
            if let textField = textFields.first {
                
                guard let urlStr = textField.text else { return }
                
                AppData.addFeed(urlStr)
            }
            
            strongSelf.feedView.tableView.reloadData()
        }))
        
        navigationController?.present(alert, animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.shared.feedURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = feedView.tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier) as? FeedTableViewCell else { return UITableViewCell() }
        
        cell.textLabel?.text = AppData.shared.feedURLs[indexPath.row]?.absoluteString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let feedURL = AppData.shared.feedURLs[indexPath.row] else { return }
        
        let parser = FeedParser(URL: feedURL)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            
            DispatchQueue.main.async { [unowned self] in
                
                let pVC = PostsViewController(withResult: result)
                self.navigationController?.show(pVC, sender: self)
            }
        }
    }
    
}
