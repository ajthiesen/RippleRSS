//
//  PostsViewController.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit
import FeedKit
import SafariServices

class PostsViewController: UIViewController {
    
    var postsView = PostsView()
    var result: Result
    var error: Error?

    init(withResult _result: Result) {
        result = _result
        
        super.init(nibName: nil, bundle: nil)
        
        // TODO: Abstract feed types
        switch result {
        case let .atom(feed):
            title = feed.title
        case let .rss(feed):
            title = feed.title
        case let .json(feed):
            title = feed.title
        case let .failure(_error):
            title = "Feed error"
            error = _error
        }
    }
    
    override func loadView() {
        
        view = postsView
        
        postsView.tableView.dataSource = self
        postsView.tableView.delegate = self
        
        showErrorIfPresent(error)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isToolbarHidden = true
        
        if let selectedIndexPath = postsView.tableView.indexPathForSelectedRow {
            postsView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    @discardableResult
    func showErrorIfPresent(_ error: Error?) -> Bool {
        
        if let error = error {
            
            let alert = UIAlertController(title: "Feed Error (FeedKit)", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController?.present(alert, animated: true)
            
            // There is an error
            return true
        }
        
        // No Error
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if result.isSuccess {
            // TODO: Abstract feed types
            switch result {
            case let .atom(feed):
                return feed.entries?.count ?? 0
            case let .rss(feed):
                return feed.items?.count ?? 0
            case let .json(feed):
                return feed.items?.count ?? 0
            case .failure:
                return 0
            }
            
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = postsView.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else { return UITableViewCell() }
        
        // TODO: Abstract feed types
        switch result {
        case let .atom(feed):
            cell.textLabel?.text = feed.entries?[indexPath.row].title
        case let .rss(feed):
            cell.textLabel?.text = feed.items?[indexPath.row].title
        case let .json(feed):
            cell.textLabel?.text = feed.items?[indexPath.row].title
        case let .failure(_error):
            cell.textLabel?.text = _error.localizedDescription
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var urlStr: String?
        var error: Error?
        
        // TODO: Abstract feed types
        switch result {
        case let .atom(feed):
            // This doesn't seem right
            urlStr = feed.entries?[indexPath.row].links?.first?.attributes?.href
        case let .rss(feed):
            urlStr = feed.items?[indexPath.row].link
        case let .json(feed):
            urlStr = feed.items?[indexPath.row].url
        case let .failure(_error):
            error = _error
        }
        
        if showErrorIfPresent(error) { return }
        
        guard let _str = urlStr else { return }
        guard let url = URL(string: _str) else { return }
            
        // TODO: Fix so "done" button returns to blank VC
        let pDVC = PostDetailViewController(url: url)
        let navVC = UINavigationController(rootViewController: pDVC)
        navVC.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationController?.showDetailViewController(navVC, sender: self)
    }
    
}
