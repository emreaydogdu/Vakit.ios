import SwiftUI

extension Color {
	init(hex: String) {
		var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
		var rgb: UInt64 = 0
		
		Scanner(string: cleanHexCode).scanHexInt64(&rgb)
		
		let redValue = Double((rgb >> 16) & 0xFF) / 255.0
		let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
		let blueValue = Double(rgb & 0xFF) / 255.0
		self.init(red: redValue, green: greenValue, blue: blueValue)
	}
}

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
	
	func getHolyGregorian(dateStr: String) -> Date? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter.date(from: dateStr)
	}
	
	func getHolyGregorianStr(dateStr: Date!) -> String {
		let calender = Calendar(identifier: .gregorian)
		
		let components = calender.dateComponents([.year, .month, .day], from: dateStr!)
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = calender
		dateFormatter.dateFormat = "EEE\ndd.MM"
		let formatteDate = dateFormatter.string(from: (calender.date(from: components) ?? dateStr)!)
		return formatteDate
	}
	
	func getHolyHijri(dateStr: Date!) -> String {
		let hijriCalender 	= Calendar(identifier: .islamicCivil)
		
		let components = hijriCalender.dateComponents([.year, .month, .day], from: dateStr!)
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = hijriCalender
		dateFormatter.dateFormat = "dd MMMM, yyyy"
		let formatteDate = dateFormatter.string(from: (hijriCalender.date(from: components) ?? dateStr)!)
		return formatteDate
	}
}

// SwipeBack Animation Feature
extension UINavigationController: UIGestureRecognizerDelegate {
	override open func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self
	}
	
	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return viewControllers.count > 1
	}
}

// Padding SafeArea Top
extension UIApplication {
	static var safeAreaInsets: UIEdgeInsets  {
		return UIApplication.shared.connectedScenes.compactMap{ ($0 as? UIWindowScene)?.keyWindow }.first!.safeAreaInsets
	}
}
