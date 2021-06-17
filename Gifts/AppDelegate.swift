//
//  AppDelegate.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var appCoordinator: AppCoordinator?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		if DatabaseService.isDatabaseEmpty() {
			DatabaseService.addMockData()
		}
		let window = UIWindow()
		self.window = window
		appCoordinator = .init(window: window)
		appCoordinator?.start()
		return true
	}

}

