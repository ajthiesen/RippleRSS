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
            
            Section("Collections") {
                NavigationLink {
                    CollectionList(items: appData.allItems, collectionName: "All Posts")
                        .frame(minWidth: 256)
                } label: {
                    HStack {
                        Image(systemName: "list.bullet.rectangle")
                        Text("All Posts")
                    }
                }
            }
            
            Section("Feeds") {
//                DisclosureGroup (isExpanded: $folderExpanded) {
                    ForEach(appData.feeds, id: \.self) { feed in
                        FeedListItem(feed: feed)
                    }
//                } label: {
//                    HStack {
//                        Image(systemName: "folder")
//                        Text("Feeds")
//                    }
//                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Feeds")
        .toolbar {

            ToolbarItem {
                HStack {
                    
                    #if os(macOS)
                    
                    // TODO: Investigate why sidebar button does not appear on iOS.
                    // My understanding is that this should automatically appear.
                    Button(action: toggleSidebar, label: { // 1
                        Image(systemName: "sidebar.leading")
                    })
                    
                    #endif
                    
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
        .sheet(isPresented: $showNewFeedSheet, onDismiss: {
            print("dismissed")
        }, content: {
            AddFeed(show: $showNewFeedSheet)
        })
    }
    
    private func toggleSidebar() {
        #if os(macOS)
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
    

}

struct FeedList_Previews: PreviewProvider {
    static var previews: some View {
        FeedList()
    }
}
