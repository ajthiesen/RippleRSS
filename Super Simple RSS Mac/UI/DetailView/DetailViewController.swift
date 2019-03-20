//
//  DetailViewController.swift
//  Super Simple RSS Mac
//
//  Created by Geof Crowl on 3/19/19.
//  Copyright © 2019 Geof Crowl. All rights reserved.
//

import Cocoa
import WebKit

class DetailViewController: NSViewController {
    
//    let detailView = DetailView()
    
    var webView: WKWebView?
    
    override func loadView() {
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView?.uiDelegate = self
        
        if let webView = webView {
            view = webView
        } else {
            print("error with webview!")
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    func load(url: URL) {
        
        title = url.absoluteString
        let request = URLRequest(url: url)
        webView?.load(request)
    }
    
}

extension DetailViewController: WKUIDelegate {
    
}
