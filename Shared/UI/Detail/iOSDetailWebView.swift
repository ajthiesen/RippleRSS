//
//  iOSDetailWebView.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 11/6/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import SwiftUI
import WebKit

struct iOSDetailWebView: UIViewRepresentable {
    
    typealias NSViewType = WKWebView
    typealias Context = UIViewRepresentableContext<Self>
    
    @State var url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }
    
    func updateUIView(_ nsView: WKWebView, context: Context) {
        
        if let url = url {
            let request = URLRequest(url: url)
            nsView.load(request)
        }
    }
    
}
