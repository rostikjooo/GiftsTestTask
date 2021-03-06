//
//  GiftDBObject.swift
//  Gifts
//
//  Created by Rost Balanyuk on 17.06.2021.
//

import Foundation
import RealmSwift

class GiftDBObject: Object {
	
	@objc dynamic var id = 0
	@objc dynamic var name = ""
	@objc dynamic var amount = 0
	
	convenience init(model: GiftModel) {
		self.init()
		self.id = model.id
		self.name = model.name
		self.amount = model.amount
	}
	
	override static func primaryKey() -> String? {
		return "id"
	}
}
