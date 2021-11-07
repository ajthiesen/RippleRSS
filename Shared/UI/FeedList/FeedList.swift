//
//  FeedList.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 11/1/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import SwiftUI

struct FeedList: View {
    
    @StateObject var appData = AppData.shared
    @State var showNewFeedSheet = false
    @State var folderExpanded = true
    
    var body: some View {
        List {
            
            DisclosureGroup (isExpanded: $folderExpanded) {
                ForEach(appData.feeds, id: \.self) { feed in
                    FeedListItem(feed: feed)
                }
            } label: {
                HStack {
                    Image(systemName: "folder")
                    Text("All Feeds")
                }
            }
            
        }
        .listStyle(.sidebar)
        .sheet(isPresented: $showNewFeedSheet, onDismiss: {
            print("dismissed")
        }, content: {
            AddFeed(show: $showNewFeedSheet)
        })
        .navigationTitle("Feeds")
        .toolbar {
            
            HStack {
                Button {
                    AppData.refreshFeeds {
                        print("Refresh: from toolbar")
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .help("Refresh Feeds")
                .keyboardShortcut("r", modifiers: .command)

                Button {
                    print("add")
                    showNewFeedSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .help("Add Feed")
                .keyboardShortcut("n", modifiers: .command)
            }
            
            
        }
    }
}

struct FeedList_Previews: PreviewProvider {
    static var previews: some View {
        FeedList()
    }
}
