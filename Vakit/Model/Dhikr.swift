import Foundation
import SwiftData

@Model
class Dhikr {
	var id: UUID
	var name: String
	var nameAr: String
	var count: Int
	static var preDefined: [Dhikr] = [
		Dhikr(id: UUID(), name: "Allahu Akbar",  nameAr: "الله أَكْبَر", count: 99),
		Dhikr(id: UUID(), name: "Subhan Allah",  nameAr: "سبحان الله", count: 99),
		Dhikr(id: UUID(), name: "Alhamdulillah",  nameAr: "الحمد لله", count: 99)
	]
	
	init(id: UUID, name: String,  nameAr: String, count: Int) {
		self.id = id
		self.name = name
		self.nameAr = nameAr
		self.count = count
	}
	
}
