import Foundation
import SwiftData

@Model
class Dhikr {
	var id: UUID
	var name: String
	var count: Int
	
	init(id: UUID, name: String, count: Int) {
		self.id = id
		self.name = name
		self.count = count
	}
}
