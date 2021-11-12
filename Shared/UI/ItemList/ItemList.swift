//
//  ItemList.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 11/1/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import SwiftUI

struct ItemList: View {
    
    @ObservedObject var feed: Feed
    
    var body: some View {
            
        List {
            
            if let items = feed.items {
                
                ForEach(items, id: \.self) { item in
                    
                    NavigationLink {
//                        Detail(feedItem: item)
                        DetailWeb(feedItem: item)
                    } label: {
                        Text(item.title ?? "nil")
                    }
                    .contextMenu {
                        Button("Copy Link", action: {
                            
                            AppData.addToPasteboard(item.url)
                            
                        })
                        Button("Open in Safari", action: {
                            AppData.openURL(item.url)
                        })
                    }
                    
                }
            }
        }
        .navigationTitle(feed.name)
        .toolbar {
            
            #if os(macOS)
            VStack (alignment: .leading) {
                Text(feed.name)
                    .bold()
                Text("\(feed.items?.count ?? 0) Posts")
            }
            #endif
            
        }
    }
}

struct ItemList_Previews: PreviewProvider {
    
    static var previews: some View {
        ItemList(feed: Feed(URL(string: "http://www.geofcrowl.com/blog/")!))
    }
}
