//
//  GiftModel.swift
//  Gifts
//
//  Created by Rost Balanyuk on 15.06.2021.
//

import Foundation

final class GiftModel: Equatable {
	
	let id: Int
	let name: String
	let amount: Int
	var isSelected: Bool
	
	static func == (lhs: GiftModel, rhs: GiftModel) -> Bool {
		return lhs.id == rhs.id
	}
	
	init(id: Int, name: String, amount: Int, isSelected: Bool = false) {
		self.id = id
		self.name = name
		self.amount = amount
		self.isSelected = isSelected
	}
	
	init(model: GiftDBObject) {
		self.id = model.id
		self.name = model.name
		self.amount = model.amount
		self.isSelected = false
	}
}
