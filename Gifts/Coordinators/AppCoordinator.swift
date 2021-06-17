//
//  AppCoordinator.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import UIKit

protocol Coordinator: AnyObject {
	
	func start()
	var childCoordinators: [Coordinator] { get }
}

final class AppCoordinator: Coordinator {
	
	private let window: UIWindow
	private(set) var childCoordinators: [Coordinator] = []
	
	init(window: UIWindow) {
		self.window = window
	}
	
	func start() {
		if DatabaseService.isDatabaseEmpty() {
			DatabaseService.addMockData()
		}
		let navigationController = UINavigationController()
		window.rootViewController = navigationController
		let giftsCoordinator = GiftsCoordinator(navigation: navigationController)
		childCoordinators.append(giftsCoordinator)
		giftsCoordinator.start()
		window.makeKeyAndVisible()
	}
}
