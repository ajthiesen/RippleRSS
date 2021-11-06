//
//  Detail.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 11/1/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import SwiftUI
import WebKit

struct DetailWeb: View {
    
    @State var feedItem: FeedItem
    
    var body: some View {
        MacDetailWebView(url: feedItem.url)
            .toolbar {
                Spacer()
                Button {
                    if let url = feedItem.url {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setData(url.dataRepresentation, forType: .URL)
                    }
                } label: {
                    Image(systemName: "doc.on.doc")
                }
                .help("Copy Link")
                .keyboardShortcut("c", modifiers: .command)
                
                Button {
                    if let url = feedItem.url {
                        NSWorkspace.shared.open(url)
                    }
                } label: {
                    Image(systemName: "safari")
                }
                .help("Open in Safari")
                .keyboardShortcut("o", modifiers: [.command, .shift])
            }
    }
}

struct MacDetailWebView: NSViewRepresentable {
    
    typealias NSViewType = WKWebView
    typealias Context = NSViewRepresentableContext<Self>
    
    @State var url: URL?
    
    func makeNSView(context: Context) -> WKWebView {
        
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        
        if let url = url {
            let request = URLRequest(url: url)
            nsView.load(request)
        }
    }
    
    
}

struct DetailWeb_Previews: PreviewProvider {
    static var previews: some View {
        Detail(feedItem: FeedItem(title: "Take-Two spent $53 million on a cancelled game that was never even announced", url: URL(string: "https://www.theverge.com/2021/11/3/22762349/take-two-cancelled-unannounced-title-from-hangar-13")))
    }
}
