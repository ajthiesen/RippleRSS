//
//  AddFeed.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 11/4/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import SwiftUI

struct AddFeed: View {
    
    @Binding var show: Bool
    @State private var newFeed = "https://www."
    @State private var isLoading = false
    @State private var isError = false
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            Text("Add Feed")
                .font(.title)
                .bold()
                .padding(.bottom)
            
            Spacer()
            
            TextField("URL", text: $newFeed, prompt: nil)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            if isError {
                Text("There was an error finding the feed.")
            }
            
            Spacer()
            
            HStack {
                
                Spacer()
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.6)
                        .frame(width: 12, height: 12)
                        .padding(.trailing, 8)
                }
                
                Button(role: .cancel) {
                    show = false
                } label: {
                    Text("Cancel")
                }
                .buttonStyle(.bordered)
                .keyboardShortcut(.escape)
                
                Button("Add Feed") {
                    isLoading = true
                    
                    FindFeed.findFeedHandler(urlStr: newFeed) { url in
                        AppData.addFeed(url.absoluteString)
                        if let lastFeed = AppData.shared.feeds.last {
                            AppData.refreshFeed(lastFeed, completion: nil)
                        }
                        isError = false
                        show = false
                        isLoading = false
                        newFeed = "https://www."
                    } onError: { error in
                        isLoading = false
                        isError = true
                    }

                    
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.return)
            }
        }
        .padding()
        .frame(minWidth: 300)
        
    }
}

struct AddFeed_Previews: PreviewProvider {
    
    @State static var show = true
    
    static var previews: some View {
        
        AddFeed(show: $show)
    }
}
