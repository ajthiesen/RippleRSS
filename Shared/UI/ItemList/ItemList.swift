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
                        Text(item.title)
                    }
                    .contextMenu {
                        Button("Copy Link", action: {
                            if let url = item.url {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setData(url.dataRepresentation, forType: .URL)
                            }
                        })
                        Button("Open in Safari", action: {
                            if let url = item.url {
                                NSWorkspace.shared.open(url)
                            }
                        })
                    }
                    
                }
            }
        }
        .toolbar {
            VStack (alignment: .leading) {
                Text(feed.name)
                    .bold()
                Text("\(feed.items?.count ?? 0) Posts")
            }
        }
//        .navigationTitle()
//        .navigationSubtitle()
    }
}

struct ItemList_Previews: PreviewProvider {
    
    static var previews: some View {
        ItemList(feed: Feed(URL(string: "http://www.geofcrowl.com/blog/")!))
    }
}
