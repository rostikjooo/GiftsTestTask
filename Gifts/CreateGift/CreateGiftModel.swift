//
//  CreateGiftModel.swift
//  Gifts
//
//  Created by Rost Balanyuk on 16.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class CreateGiftModel {
	
	let completion: (GiftModel?) -> ()
	
	let name = PublishSubject<String>()
	let amount = PublishSubject<Int>()
	let create = PublishSubject<Void>()
	let close = PublishSubject<Void>()
	let isValid = PublishSubject<Bool>()
	
	private let disposeBag = DisposeBag()
	
	init(completion: @escaping (GiftModel?) -> ()) {
		self.completion = completion
		setupBindings()
	}
	
	private func setupBindings() {
		Observable.combineLatest(name, amount).map { $0.count > 3 && (1...100).contains($1) }
			.bind(to: isValid).disposed(by: disposeBag)
		
		Observable.combineLatest(name, amount, create)
			.map { GiftModel(id: -1, name: $0.0, amount: $0.1) }
			.subscribe(onNext: { [weak self] item in
				self?.completion(item)
			}).disposed(by: disposeBag)
		
		close.subscribe { [weak self] _ in
			self?.completion(nil)
		}.disposed(by: disposeBag)
	}
}
