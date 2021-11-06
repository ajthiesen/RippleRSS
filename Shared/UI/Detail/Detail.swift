//
//  Detail.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 11/1/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import SwiftUI

struct Detail: View {
    
    @State var feedItem: FeedItem
    @State var showWeb = false
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                
                Text(feedItem.title)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.title)
                    .padding(.top)
                    .padding(.bottom)
                
//                if let content = feedItem.content {
//                    Text(content)
//                }
                
                Divider()
                
                if let url = feedItem.url {
                    
                    if showWeb {
                        #if os(macOS)
                        MacDetailWebView(url: url)
                        #elseif os(iOS)
                        iOSDetailWebView(url: url)
                        #endif
                    } else {
                        Button {
                            showWeb = true
                        } label: {
                            Text("Continue Reading")
                        }
                    }
                    
                }
            }
            .frame(maxWidth: 640, alignment: .leading)
            .padding()
        }
    }
}

struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        Detail(feedItem: FeedItem(title: "Take-Two spent $53 million on a cancelled game that was never even announced", url: URL(string: "https://www.theverge.com/2021/11/3/22762349/take-two-cancelled-unannounced-title-from-hangar-13")))
    }
}
