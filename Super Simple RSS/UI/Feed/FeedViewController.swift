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
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isToolbarHidden = false
        
        if let selectedIndexPath = feedView.tableView.indexPathForSelectedRow {
            feedView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    @objc func addFeedItem() {
        
        let alert = UIAlertController(title: "Add A Feed", message: "Feed URL?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.returnKeyType = .done
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
        
        var cell: FeedTableViewCell?
        if let _cell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell {
            cell = _cell
            cell?.activityIndicator.startAnimating()
        }
        
        guard let feedURL = AppData.shared.feedURLs[indexPath.row] else { return }
        let parser = FeedParser(URL: feedURL)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            
            DispatchQueue.main.async { [unowned self] in
                
                cell?.activityIndicator.stopAnimating()
                let pVC = PostsViewController(withResult: result)
                self.navigationController?.show(pVC, sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Edit feed
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { [unowned self] (action, indexPath)  in
            
            let alert = UIAlertController(title: "Edit Feed", message: "Feed URL?", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.returnKeyType = .done
                textField.text = AppData.shared.feedURLs[indexPath.row]?.absoluteString
            }
            
            alert.addAction(UIAlertAction(title: "Save Changes", style: .default, handler: { [weak self] (action) in
                
                guard let strongSelf = self else { return }
                guard let textFields = alert.textFields else { return }
                
                if let textField = textFields.first {
                    
                    guard let urlStr = textField.text else { return }
                    
                    AppData.editFeed(urlStr, at: indexPath.row)
                }
                
                strongSelf.feedView.tableView.reloadData()
            }))
            
            self.navigationController?.present(alert, animated: true)
        })
        editAction.backgroundColor = UIColor.blue
        
        // Delete feed
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            AppData.deleteFeed(at: indexPath.row)
            tableView.reloadData()
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction, editAction]
    }
    
}
