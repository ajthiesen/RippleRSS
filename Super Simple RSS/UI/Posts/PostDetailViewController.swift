//
//  PostDetailNavigationViewController.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 2/4/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import UIKit
import WebKit

class PostDetailViewController: UIViewController {
    
    var webView: WKWebView?
    var url: URL
    
    init(url _url: URL) {
        
        url = _url
        
        super.init(nibName: nil, bundle: nil)
        
        title = url.absoluteString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.uiDelegate = self
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        let request = URLRequest(url: url)
        webView?.load(request)
    }

}

extension PostDetailViewController: WKUIDelegate {
    
}
