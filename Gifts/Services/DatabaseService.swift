//
//  DatabaseService.swift
//  Gifts
//
//  Created by Rost Balanyuk on 16.06.2021.
//

import Foundation
import RealmSwift

struct DatabaseService {
	
	static func fetchAllGifts() -> [GiftModel] {
		let realm = try! Realm()
		return realm.objects(GiftDBObject.self).map {
			GiftModel(model: $0)
		}
	}
	
	static func removeGift(item: GiftModel) {
		let realm = try! Realm()
		guard let objectToDelete = realm.object(ofType: GiftDBObject.self, forPrimaryKey: item.id) else {
			return
		}
		try! realm.write {
			realm.delete(objectToDelete)
		}
	}
	
	static func addGift(item: GiftModel) -> GiftModel {
		let realm = try! Realm()
		let objects = realm.objects(GiftDBObject.self)
		let maxId = objects.max(ofProperty: "id") as Int?
		let newItem = GiftModel(id: (maxId ?? -1) + 1, name: item.name, amount: item.amount)
		try! realm.write({
			realm.add(GiftDBObject(model: newItem))
		})
		return newItem
	}
	
	static func isDatabaseEmpty() -> Bool {
		let realm = try! Realm()
		return realm.objects(GiftDBObject.self).count == 0
	}
	
	static func addMockData() {
		let entries = Self.mockData.map { GiftDBObject(model:$0) }
		let realm = try! Realm()
		try! realm.write {
			realm.add(entries)
		}
	}
	
	static var mockData: [GiftModel] {
		return [
			.init(id: 1, name: "Cheap Simple Gift", amount: 3),
			.init(id: 2, name: "Simple Mistery Gift", amount: 7),
			.init(id: 3, name: "Bicycle", amount: 13),
			.init(id: 4, name: "Shotgun", amount: 27),
			.init(id: 5, name: "Roses", amount: 31),
			.init(id: 6, name: "THE ANSWER TO LIFE, THE UNIVERSE AND EVERYTHING", amount: 42),
			.init(id: 7, name: "Killer for an hour", amount: 47),
			.init(id: 8, name: "Aliens Guano", amount: 51),
			.init(id: 9, name: "Expensive Gift", amount: 100),
			.init(id: 10, name: "Cheapest Thing", amount: 1),
			.init(id: 11, name: "Second Cheapest Thing", amount: 2),
			.init(id: 12, name: "Mistery Sequel Gift", amount: 7),
			.init(id: 13, name: "The Witcher. The Last Wish", amount: 13),
			.init(id: 14, name: "Amy's White house", amount: 27),
			.init(id: 15, name: "Hemingways Book", amount: 31),
			.init(id: 16, name: "THE ANSWER TO LIFE, THE UNIVERSE AND EVERYTHING SEQUEL!!!", amount: 42),
			.init(id: 17, name: "Extra chromosome", amount: 47),
			.init(id: 18, name: "Secret area ticket", amount: 51),
			.init(id: 19, name: "Another expensive Gift", amount: 100)
		]
	}
}
