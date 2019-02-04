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

    init(withResult _result: Result) {
        result = _result
        super.init(nibName: nil, bundle: nil)
        
        title = result.rssFeed?.title ?? "Feed Posts"
    }
    
    override func loadView() {
        
        view = postsView
        
        postsView.tableView.dataSource = self
        postsView.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
        
        if let selectedIndexPath = postsView.tableView.indexPathForSelectedRow {
            postsView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if result.isSuccess {
            return result.rssFeed?.items?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = postsView.tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else { return UITableViewCell() }
        
        guard let feed = result.rssFeed else { return UITableViewCell() }
        
        cell.textLabel?.text = feed.items?[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let feed = result.rssFeed else { return }
        guard let items = feed.items else { return }
        let item = items[indexPath.row]
        
        if let url = URL(string: item.link ?? "") {
            let sVC = SFSafariViewController(url: url)
            navigationController?.present(sVC, animated: true)
        }
    }
    
}
