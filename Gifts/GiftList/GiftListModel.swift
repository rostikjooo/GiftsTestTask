//
//  GiftListModel.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class GiftListModel {
	
	let syncData: PublishSubject<Void> = .init()
	let totalPrice: BehaviorRelay<Int> = .init(value: 0)
	let overflowEvent: PublishSubject<Void> = .init()
	let itemDeleted: PublishSubject<Int> = .init()
	let addNewGiftItem: PublishSubject<Void> = .init()
	var cellModels: [GiftTableViewCellModel] = []
	
	private weak var coordinator: GiftsCoordinator!
	private let disposeBag = DisposeBag()
	private var data: [GiftModel] = []
	private var selectableDisposeBag = DisposeBag()
	
	init(coordinator: GiftsCoordinator) {
		self.coordinator = coordinator
		fetchData()
		bindSubscriptions()
	}
	
	private func createCellViewModels() {
		let cellModels:[GiftTableViewCellModel] = data.map {
			GiftTableViewCellModel(item: $0)
		}
		self.cellModels = cellModels
		rebindDataSelection()
	}
	
	private func bindSubscriptions() {
		itemDeleted.subscribe(onNext: { [weak self] index in
			guard let self = self else { return }
			self.removeElement(item: self.data[index])
			self.data.remove(at: index)
			self.cellModels.remove(at: index)
			self.totalPrice.accept(self.calculateAmount())
		}).disposed(by: disposeBag)
		
		addNewGiftItem.subscribe(onNext: { [weak self] _ in
			self?.coordinator.startGiftCreation(completion: { [weak self] newGift in
				self?.addNewElement(item: newGift)
			})
		}).disposed(by: disposeBag)
	}
	
	private func calculateAmount() -> Int {
		let selects = self.data.filter { $0.isSelected }
		return selects.reduce(0, { $0 + $1.amount })
	}
	
	private func calculateOverdraw(
		_ amount: Int,
		_ selects: [GiftModel],
		_ lastSelectedModel: GiftModel,
		_ self: GiftListModel
	) {
		var sum = amount
		var candidates = selects.filter { model in
			lastSelectedModel.id != model.id
		}
		while sum > 100 {
			let gap = sum - 100
			guard let candidate = (candidates.min { lhs, rhs in
				abs(lhs.amount - gap) < abs(rhs.amount - gap)
			}) else { break }
			self.cellModels.first { model in
				model.item.id == candidate.id
			}?.checkSelected.onNext(false)
			sum -= candidate.amount
			_ = candidates.firstIndex(of: candidate).map { candidates.remove(at: $0) }
		}
	}
	
	private func rebindDataSelection() {
		selectableDisposeBag = DisposeBag()
		let selections = Observable.from(cellModels.map { $0.modelChange }).flatMap { $0 }
		selections.subscribe(onNext: { [weak self] lastSelectedModel in
			guard let self = self else { return }
			let selects = self.data.filter { $0.isSelected }
			let amount = selects.reduce(0, { $0 + $1.amount })
			if amount <= 100 {
				self.totalPrice.accept(amount)
			} else {
				self.overflowEvent.onNext(())
				self.calculateOverdraw(amount, selects, lastSelectedModel, self)
			}
		}).disposed(by: selectableDisposeBag)
	}
	
	private func fetchData() {
		let data = DatabaseService.fetchAllGifts()
		self.data = data
		createCellViewModels()
		syncData.onNext(())
	}
	
	private func addNewElement(item: GiftModel) {
		let itemFromDB = DatabaseService.addGift(item: item)
		data.append(itemFromDB)
		createCellViewModels()
		syncData.onNext(())
	}
	
	private func removeElement(item: GiftModel) {
		DatabaseService.removeGift(item: item)
	}
}
