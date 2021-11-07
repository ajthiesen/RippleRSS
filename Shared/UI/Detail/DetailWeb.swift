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
        VStack {
            #if os(macOS)
            MacDetailWebView(url: feedItem.url)
            #elseif os(iOS)
            iOSDetailWebView(url: feedItem.url)
            #endif
        }
            .toolbar {
                
                Spacer()
                
                Button {
                    AppData.addToPasteboard(feedItem.url)
                } label: {
                    Image(systemName: "doc.on.doc")
                }
                .help("Copy Link")
                .keyboardShortcut("c", modifiers: .command)
                
                Button {
                    AppData.openURL(feedItem.url)
                } label: {
                    Image(systemName: "safari")
                }
                .help("Open in Safari")
                .keyboardShortcut("o", modifiers: [.command, .shift])
            }
    }
}

struct DetailWeb_Previews: PreviewProvider {
    static var previews: some View {
        Detail(feedItem: FeedItem(title: "Take-Two spent $53 million on a cancelled game that was never even announced", url: URL(string: "https://www.theverge.com/2021/11/3/22762349/take-two-cancelled-unannounced-title-from-hangar-13")))
    }
}
