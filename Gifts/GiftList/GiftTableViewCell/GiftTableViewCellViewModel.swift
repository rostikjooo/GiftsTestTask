//
//  GiftTableViewCellViewModel.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class GiftTableViewCellViewModel {
  
	private let model: GiftTableViewCellModel
	
	var title: String {
		return model.item.name
	}
	
	var subtitle: String {
		return String(model.item.amount) + " points"
	}
	
	var isSelected: PublishSubject<Bool> {
		return model.checkSelected
	}
	
	var currentSelectionValue: Bool {
		return model.item.isSelected
	}
	
	init(model: GiftTableViewCellModel) {
		self.model = model
	}
}
