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
    static let addFeedItem = #selector(FeedsViewController.addFeedItem(_:))
}

class FeedsViewController: UIViewController {
    
    let feedsView = FeedsView()
    
    private lazy var dataSource = makeDataSource()
    
    typealias DataSource = UITableViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
    enum Section: CaseIterable {
        case smart
        case feeds
        
        var header: String? {
            switch self {
            case .smart: return "Smart Groups"
            case .feeds: return "Feeds"
            }
        }
    }
    
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
        
        feedsView.tableView.delegate = self
        
        #if targetEnvironment(macCatalyst)
        navigationController?.setNavigationBarHidden(true, animated: false)
        #endif
        
        AppData.refreshFeeds { [unowned self] in
            self.applySnapshot()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let selectedIndexPath = feedsView.tableView.indexPathForSelectedRow {
            feedsView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        applySnapshot(animatingDifferences: false)
    }
    
    func makeDataSource() -> FeedsDataSource {
        
        let dataSource = FeedsDataSource(
            tableView: feedsView.tableView,
            cellProvider: { (tableView, indexPath, hashable) ->
                UITableViewCell? in
                
                guard let feedDiffable = hashable as? Feed.Diffable else { return nil }
                let feed = feedDiffable.feed
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: FeedTableViewCell.identifier,
                    for: indexPath)// as? UITableViewCell
                
                cell.textLabel?.text = feed.name ?? feed.url.absoluteString
                
                return cell
        })
        
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        
        var snapshot = Snapshot()
        
        snapshot.appendSections([.smart, .feeds])
        
        let feedsDiffable = feeds.compactMap({ feed in
            return Feed.Diffable(feed: feed)
        })
        
        snapshot.appendItems(feedsDiffable, toSection: .feeds)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func feedItemSuccess(url: URL) {
        
        print("Success")
        let alert = UIAlertController(title: "Feed Found", message: "Found a feed at: \(url.absoluteString)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            AppData.addFeed(url.absoluteString)
            AppData.refreshFeeds {
                // TODO: This runs on every feed item
                self.applySnapshot()
            }
        }))
        
        navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func addFeedItem(_ sender: Any) {
        addFeedItem()
    }
    
    func addFeedItem(message: String? = nil, urlString: String? = nil) {
        
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
            
            strongSelf.applySnapshot()
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

//
// MARK: - DataSource overrides
//

extension FeedsViewController {
    
    class FeedsDataSource: DataSource {
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

            let section = self.snapshot().sectionIdentifiers[section]
            if self.snapshot().itemIdentifiers(inSection: section).count == 0 {
                return nil
            }
            return section.header
        }
        
    }
}

//
// MARK: - UITableViewDelegate Methods
//

extension FeedsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.shared.feedURLs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let feedDiffable = dataSource.itemIdentifier(for: indexPath) as? Feed.Diffable else { return }
        let feed = feedDiffable.feed
        
        var cell: FeedTableViewCell?
        if let _cell = tableView.cellForRow(at: indexPath) as? FeedTableViewCell {
            cell = _cell
            cell?.activityIndicator.startAnimating()
        }

        cell?.activityIndicator.stopAnimating()
        
        if let feedsSplitVC = splitViewController as? FeedsSplitViewController {
            feedsSplitVC.postsVC.feed = feed
            feedsSplitVC.show(.supplementary)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let feedDiffable = dataSource.itemIdentifier(for: indexPath) as? Feed.Diffable else { return nil }
        let feed = feedDiffable.feed
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [unowned self] (menuElement) -> UIMenu? in
            
            let refresh = UIAction(title: "Refresh", image: UIImage(systemName: "arrow.clockwise")) { (action) in
                AppData.refreshFeed(feed) {
                    applySnapshot()
                }
            }
            
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { (action) in
                
                let alert = UIAlertController(title: "Edit Feed", message: "Feed URL?", preferredStyle: .alert)
                
                alert.addTextField { (textField) in
                    textField.returnKeyType = .done
                    textField.text = self.feeds[indexPath.row].url.absoluteString
                }
                
                alert.addAction(UIAlertAction(title: "Save Changes", style: .default, handler: { [weak self] (action) in
                    
                    guard let strongSelf = self else { return }
                    guard let textFields = alert.textFields else { return }
                    
                    if let textField = textFields.first {
                        
                        guard let urlStr = textField.text else { return }
                        
                        AppData.editFeed(urlStr, at: indexPath.row)
                        strongSelf.applySnapshot()
                    }
                    
                    strongSelf.applySnapshot()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                self.navigationController?.present(alert, animated: true)
            }
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { [unowned self] (action) in
                
                let alert = UIAlertController(title: "Delete \(feed.name ?? feed.url.absoluteString)?", message: "This action cannot be undone", preferredStyle: .alert)
                
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                    AppData.deleteFeed(feed)
                    self.applySnapshot()
                }))
                
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
            
            
            let modifiers = UIMenu(title: "", image: nil, options: .displayInline, children: [edit, delete])
            
            return UIMenu(title: "", image: nil, children: [refresh, modifiers])
        }
        
        return configuration
    }
    
}
