//
//  FeedsSplitView.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 10/31/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import SwiftUI

struct RootView: View {
    
    var body: some View {
        
        NavigationView {
            
            FeedList()
                .frame(minWidth: 256)

            Text("No feed selected")
                .frame(minWidth: 256)
                .toolbar {
                    Text("")
                }
            
            Text("No post selected")
                .toolbar {
                    Text("")
                }
        }
        .navigationViewStyle(.columns)
        
    }

}

struct FeedsSplitView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
