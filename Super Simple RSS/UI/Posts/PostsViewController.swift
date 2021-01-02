//
//  PostsViewController.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/3/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit
import SafariServices

class PostsViewController: UIViewController {
    
    var postsView = PostsView()

    var error: Error?
    var feed: Feed? {
        didSet {
            title = feed?.name
            postsView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        
        view = postsView
        
        postsView.tableView.dataSource = self
        postsView.tableView.delegate = self
        
        showErrorIfPresent(error)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        #if targetEnvironment(macCatalyst)
        navigationController?.setNavigationBarHidden(true, animated: false)
        #endif
        
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
    
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feed?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = postsView.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else { return UITableViewCell() }
        
        guard let items = feed?.items else { return cell }
        
        cell.textLabel?.text = items[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let items = feed?.items else { return }
        guard let url = items[indexPath.row].url else { return }
        
        let pDVC = PostDetailViewController(url: url)
        let navVC = UINavigationController(rootViewController: pDVC)
        navigationController?.showDetailViewController(navVC, sender: self)
    }
    
}
