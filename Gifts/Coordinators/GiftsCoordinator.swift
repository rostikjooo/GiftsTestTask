//
//  GiftsCoordinator.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import UIKit
import RxSwift

final class GiftsCoordinator: Coordinator {
	
	private let navigation: UINavigationController
	private(set) var childCoordinators: [Coordinator] = []
	private var newGiftDisposeBag = DisposeBag()
	
	init(navigation: UINavigationController) {
		self.navigation = navigation
	}
	
	func start() {
		let giftListModel: GiftListModel = .init(coordinator: self)
		let giftListViewModel: GiftListViewModel = .init(model: giftListModel)
		let giftListView = GiftListViewController(viewModel: giftListViewModel)
		
		navigation.setViewControllers([giftListView], animated: false)
	}
	
	func startGiftCreation(completion: @escaping (GiftModel) -> Void) {
		newGiftDisposeBag = .init()
		let navigationController = UINavigationController()
		let model: CreateGiftModel = CreateGiftModel { model in
			navigationController.dismiss(animated: true, completion: nil)
			model.map { completion($0) }
		}
		let viewModel: CreateGiftViewModel = CreateGiftViewModel(model: model)
		let createGiftViewController = CreateGiftViewController(viewModel: viewModel)
		navigationController.setViewControllers([createGiftViewController], animated: true)
		self.navigation.present(navigationController, animated: true, completion: nil)
	}
}
