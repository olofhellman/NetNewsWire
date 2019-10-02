//
//  AppDelegate.swift
//  NetNewsWire
//
//  Created by Maurice Parker on 6/28/19.
//  Copyright © 2019 Ranchero Software. All rights reserved.
//

import UIKit
import Account

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
    var window: UIWindow?
	var coordinator = SceneCoordinator()
	
    // UIWindowScene delegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		
		window = UIWindow(windowScene: scene as! UIWindowScene)
		window!.tintColor = AppAssets.primaryAccentColor
		window!.rootViewController = coordinator.start(for: window!.frame.size)

		if let shortcutItem = connectionOptions.shortcutItem {
			window!.makeKeyAndVisible()
			handleShortcutItem(shortcutItem)
			return
		}
		
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
			self.coordinator.handle(userActivity)
        }
		
		window!.makeKeyAndVisible()
    }
	
	func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		handleShortcutItem(shortcutItem)
		completionHandler(true)
	}
	
	func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
		coordinator.handle(userActivity)
	}
	
	func sceneDidEnterBackground(_ scene: UIScene) {
		appDelegate.prepareAccountsForBackground()
	}
	
	func sceneWillEnterForeground(_ scene: UIScene) {
		appDelegate.prepareAccountsForForeground()
	}
	
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
		return coordinator.stateRestorationActivity
    }

}

private extension SceneDelegate {
	
	func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) {
		switch shortcutItem.type {
		case "com.ranchero.NetNewsWire.FirstUnread":
			coordinator.selectFirstUnreadInAllUnread()
		case "com.ranchero.NetNewsWire.ShowSearch":
			coordinator.showSearch()
		case "com.ranchero.NetNewsWire.ShowAdd":
			coordinator.showAdd(.feed)
		default:
			break
		}
	}
	
}
