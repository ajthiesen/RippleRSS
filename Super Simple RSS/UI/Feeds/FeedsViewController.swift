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
    static let addFeedItem = #selector(FeedsViewController.addFeedItem)
}

class FeedsViewController: UIViewController {
    
    let feedsView = FeedsView()
    
    fileprivate var feeds: [Feed] {
        return AppData.shared.feeds
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "Feeds"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .addFeedItem)
    }
    
    override func loadView() {
        
        view = feedsView
        
        feedsView.tableView.dataSource = self
        feedsView.tableView.delegate = self
        
        #if targetEnvironment(macCatalyst)
        navigationController?.setNavigationBarHidden(true, animated: false)
        #endif
        
        AppData.refreshFeeds { [unowned self] in
            self.feedsView.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let selectedIndexPath = feedsView.tableView.indexPathForSelectedRow {
            feedsView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    func feedItemSuccess(url: URL) {
        
        print("Success")
        let alert = UIAlertController(title: "Feed Found", message: "Found a feed at: \(url.absoluteString)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            AppData.addFeed(url.absoluteString)
            AppData.refreshFeeds {
                // TODO: This runs on every feed item
                self.feedsView.tableView.reloadData()
            }
        }))
        
        navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func addFeedItem(message: String? = nil, urlString: String? = nil) {
        
        let message = message ?? "Enter a website or URL to a RSS/JSON feed"
        
        let alert = UIAlertController(title: "Add A Feed", message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.returnKeyType = .done
            textField.placeholder = "Site or Feed URL"
            textField.text = urlString ?? "http://www."
        }
        
        alert.addAction(UIAlertAction(title: "Add Feed", style: .default, handler: { [weak self] (action) in
            
            guard let strongSelf = self else { return }
            guard let textFields = alert.textFields else { return }
            
            if let textField = textFields.first {
                
                guard let urlStr = textField.text else { return }
                
                FindFeed.findFeedHandler(urlStr: urlStr) { (url) in
                    
                    strongSelf.feedItemSuccess(url: url)
                    
                } onError: { [unowned self] (error) in
                    
                    print(error?.localizedDescription ?? "nil error")
                    self?.addFeedItem(message: "There was an error finding a feed", urlString: urlStr)
                }
            }
            
            strongSelf.feedsView.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        navigationController?.present(alert, animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FeedsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.shared.feedURLs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = feedsView.tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier) as? FeedTableViewCell else { return UITableViewCell() }
        
        if indexPath.row >= feeds.count { return cell }
        if indexPath.row < 0 { return cell }
        
        let feed = feeds[indexPath.row]
        cell.textLabel?.text = feed.name ?? feed.url?.absoluteString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row >= feeds.count { return }
        if indexPath.row < 0 { return }
        let feed = feeds[indexPath.row]
        
        var cell: FeedTableViewCell?
        if let _cell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell {
            cell = _cell
            cell?.activityIndicator.startAnimating()
        }

        cell?.activityIndicator.stopAnimating()
        
        if let feedsSplitVC = splitViewController as? FeedsSplitViewController {
            feedsSplitVC.postsVC.feed = feed
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let feed = feeds[indexPath.row]
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (menuElement) -> UIMenu? in
            
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { (action) in
                
                let alert = UIAlertController(title: "Edit Feed", message: "Feed URL?", preferredStyle: .alert)
                
                alert.addTextField { (textField) in
                    textField.returnKeyType = .done
                    textField.text = AppData.shared.feeds[indexPath.row].url?.absoluteString
                }
                
                alert.addAction(UIAlertAction(title: "Save Changes", style: .default, handler: { [weak self] (action) in
                    
                    guard let strongSelf = self else { return }
                    guard let textFields = alert.textFields else { return }
                    
                    if let textField = textFields.first {
                        
                        guard let urlStr = textField.text else { return }
                        
                        AppData.editFeed(urlStr, at: indexPath.row)
                        self?.feedsView.tableView.reloadData()
                    }
                    
                    strongSelf.feedsView.tableView.reloadData()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                self.navigationController?.present(alert, animated: true)
            }
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { [unowned self] (action) in
                
                AppData.deleteFeed(feed)
                self.feedsView.tableView.reloadData()
            }
            
            return UIMenu(title: "", image: nil, children: [edit, delete])
        }
        
        return configuration
    }
    
}
