import SwiftUI

public extension Date {

	func getMonthString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM"
		
		let month = dateFormatter.string(from: Date())
		return month.uppercased()
	}

	func getDay() -> String {
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd"
		
		let day = dateFormatter.string(from: Date())
		
		return day
		
	}

	func getWeekDay() -> String {
		   let dateFormatter = DateFormatter()
		   dateFormatter.dateFormat = "EEEE"
		   let weekDay = dateFormatter.string(from: Date())
		   return weekDay
	 }

	func getMonth() -> String {
		   let dateFormatter = DateFormatter()
		   dateFormatter.dateFormat = "MMMM"
		   let weekDay = dateFormatter.string(from: Date())
		   return weekDay
	 }

	func getNavDate() -> String {
		
		let day	= getDay()
		let weekDay	= getWeekDay()
		let month	= getMonth()
		
		return "\(weekDay) \(day), \(month)"
	}
	
	func getHijriDate() -> String {
		let currentDate 	= Date()
		let hijriCalender 	= Calendar(identifier: .islamicCivil)
		
			let components = hijriCalender.dateComponents([.year, .month, .day], from: currentDate)
			let dateFormatter = DateFormatter()
			dateFormatter.calendar = hijriCalender
			dateFormatter.dateFormat = "dd MMMM, yyyy"
			let formatteDate = dateFormatter.string(from: hijriCalender.date(from: components) ?? currentDate)
			return formatteDate
	}

}
