//
//  GiftListViewModel.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import Foundation
import RxCocoa
import RxSwift

final class GiftListViewModel {
	
	private let model: GiftListModel
  
	let title = "Gifts"
	
	var cellViewModels: [GiftTableViewCellViewModel] {
		return model.cellModels.map {
			GiftTableViewCellViewModel(model: $0)
		}
	}
	
	var reloadTable: Observable<Void> {
		return model.syncData
	}
	
	var totalPrice: Observable<Int> {
		return model.totalPrice.asObservable()
	}
	
	var overflow: Observable<Void> {
		return model.overflowEvent.asObservable()
	}
	
	var itemDeleted: AnyObserver<IndexPath> {
		return model.itemDeleted.mapObserver { indexPath in
			return indexPath.row
		}
	}
	
	var addNewGift: PublishSubject<Void> {
		return model.addNewGiftItem
	}
	
	init(model: GiftListModel) {
		self.model = model
	}
}
