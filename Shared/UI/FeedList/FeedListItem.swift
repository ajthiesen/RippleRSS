//
//  SwiftUIView.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 11/5/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import SwiftUI

struct FeedListItem: View {
    
    @ObservedObject var feed: Feed
    
    var body: some View {
        NavigationLink {
            
            ItemList(feed: feed)
                .frame(minWidth: 256)
            
        } label: {
            HStack {
                Text(feed.name)
            }
        }
        .contextMenu {
            Button("Copy Feed URL", action: {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setData(feed.url.dataRepresentation, forType: .URL)
            })
            Button("Edit", action: {
                // TODO: Create a new window
            })
            Divider()
            Button("Delete", action: {
                AppData.deleteFeed(feed)
            })
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        FeedListItem(feed: Feed(URL(string: "http://www.geofcrowl.com/blog/feed/")!))
    }
}
