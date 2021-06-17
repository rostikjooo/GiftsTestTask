//
//  GiftTableViewCellModel.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import Foundation
import RxSwift

final class GiftTableViewCellModel {
	var item: GiftModel
	let modelChange = PublishSubject<GiftModel>()
	let checkSelected = PublishSubject<Bool>()
	private let disposeBag = DisposeBag()
	
	init(item: GiftModel) {
		self.item = item
		setup()
	}
	
	private func setup() {
		checkSelected.observe(on:MainScheduler.asyncInstance)
			.subscribe(onNext: { [weak self] isSelected in
				guard let self = self else { return }
				self.item.isSelected = isSelected
				self.modelChange.onNext(self.item)
			}).disposed(by: disposeBag)
	}
}
