//
//  CreateGiftViewModel.swift
//  Gifts
//
//  Created by Rost Balanyuk on 16.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class CreateGiftViewModel {
	
	private let model: CreateGiftModel
	
	let title = "New Gift"
	let giftAmountPlaceholder = "enter price for gift"
	let giftTitlePlaceholder = "Give gift a name"
	let createButtonTitle = "Create"
	let closeButtonTitle = "Close"
	
	var name: PublishSubject<String> {
		model.name
	}
	
	var amount: AnyObserver<String> {
		model.amount.mapObserver {
			Int($0) ?? 0
		}
	}
	
	var isValid: PublishSubject<Bool> {
		model.isValid
	}
	
	var create: PublishSubject<Void> {
		model.create
	}
	
	var close: PublishSubject<Void> {
		model.close
	}
	
	init(model: CreateGiftModel) {
		self.model = model
	}
}
