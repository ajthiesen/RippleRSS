//
//  SceneDelegate.swift
//  Super Simple RSS
//
//  Created by Geof Crowl on 1/1/21.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            
            let window = UIWindow(windowScene: windowScene)
            
//            let feedSplitVC = FeedsSplitViewController(style: .tripleColumn)
            window.rootViewController = UIHostingController(rootView: RootView())
            window.makeKeyAndVisible()
            
            #if targetEnvironment(macCatalyst)
            if let titlebar = windowScene.titlebar {
                
                let toolbar = NSToolbar(identifier: "com.geofcrowl.Super-Simple-RSS.toolbar")
                
                toolbar.delegate = self
                toolbar.allowsUserCustomization = false
                
                titlebar.toolbar = toolbar
                // TODO: Unified is larger and the toolbar button
                // items don't properly fill the space
                titlebar.toolbarStyle = .unified
                titlebar.titleVisibility = .hidden
            }
            #endif
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

#if targetEnvironment(macCatalyst)
fileprivate extension Selector {
    static let refreshFeeds = #selector(SceneDelegate.refreshFeeds(_:))
    static let newFeed = #selector(SceneDelegate.newFeed(_:))
}

private extension NSToolbarItem.Identifier {
    
    static let refreshFeeds = NSToolbarItem.Identifier("com.geofcrowl.Super-Simple-RSS.refreshFeeds")
    static let newFeed = NSToolbarItem.Identifier("com.geofcrowl.Super-Simple-RSS.newFeed")
}

extension SceneDelegate: NSToolbarDelegate {
    
    var toolbarIdentifiers: [NSToolbarItem.Identifier] {
        [
            .refreshFeeds,
            .flexibleSpace,
            .newFeed,
            .primarySidebarTrackingSeparatorItemIdentifier,
            .supplementarySidebarTrackingSeparatorItemIdentifier,
            .flexibleSpace,
        ]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarIdentifiers
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return toolbarIdentifiers
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var toolbarItem: NSToolbarItem?
        
        switch itemIdentifier {
        
        case .refreshFeeds:
            
            let barItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: .refreshFeeds)
            
            toolbarItem = NSToolbarItem(itemIdentifier: .refreshFeeds, barButtonItem: barItem)
            
        case .newFeed:
            
            let barItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .newFeed)
            
            toolbarItem = NSToolbarItem(itemIdentifier: .newFeed, barButtonItem: barItem)
            
        default:
            toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        }
        
        return toolbarItem
    }
    
    @objc func refreshFeeds(_ sender: Any) {

        guard let window = self.window else { return }
        guard let feedsSplitVC = window.rootViewController as? FeedsSplitViewController else { return }
        
        AppData.refreshFeeds {
            // TODO: Refresh notification or combine publisher
            feedsSplitVC.feedsVC.applySnapshot()
        }
    }
    
    @objc func newFeed(_ sender: Any) {
        guard let window = window else { return }
        guard let feedsSplitVC = window.rootViewController as? FeedsSplitViewController else { return }
        
        // TODO: Refresh notification or combine publisher
        feedsSplitVC.feedsVC.addFeedItem()
    }
}
#endif
