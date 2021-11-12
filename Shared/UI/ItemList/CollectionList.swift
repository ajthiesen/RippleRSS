//
//  ItemList.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 11/1/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import SwiftUI

struct CollectionList: View {
    
    @Binding var items: [FeedItem]
    @State var collectionName: String
    
    var body: some View {
            
        List {
            
            ForEach(items, id: \.self) { item in
                
                NavigationLink {
//                        Detail(feedItem: item)
                    DetailWeb(feedItem: item)
                } label: {
                    Text(item.title)
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
        .navigationTitle(collectionName)
        .toolbar {
            
            #if os(macOS)
            VStack (alignment: .leading) {
                Text(collectionName)
                    .bold()
                Text("\(items.count) Posts")
            }
            #endif
            
        }
    }
}

struct CollectionList_Previews: PreviewProvider {
    
    static var previews: some View {
        ItemList(feed: Feed(URL(string: "http://www.geofcrowl.com/blog/")!))
    }
}
