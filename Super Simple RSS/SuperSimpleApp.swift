//
//  SuperSimpleApp.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 11/6/21.
//  Copyright © 2021 Geof Crowl. All rights reserved.
//

import SwiftUI

@main
struct SuperSimpleApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    AppData.refreshFeeds {
                        print("App: refreshFeeds")
                    }
                }
        }
        .commands {
            SidebarCommands()
            CommandMenu("Custom Menu") {
                Button("Say Hello") {
                    print("Hello from Menu")
                }
                .keyboardShortcut("h")
            }
        }
        
        WindowGroup("New Feed") {
            Text("New feed")
                .frame(width: 250, height: 250)
        }
        
    }
}
