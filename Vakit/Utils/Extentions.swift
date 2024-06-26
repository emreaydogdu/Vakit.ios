import SwiftUI

extension View {
	@ViewBuilder
	func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
		if conditional {
			content(self)
		} else {
			self
		}
	}
}

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

extension Date: RawRepresentable {
	public var rawValue: String {
		self.timeIntervalSinceReferenceDate.description
	}
	
	public init?(rawValue: String) {
		self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
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
	
	func getHolyGregorianStrNorm(dateStr: Date!) -> String {
		let calender = Calendar(identifier: .gregorian)
		
		let components = calender.dateComponents([.year, .month, .day], from: dateStr!)
		let dateFormatter = DateFormatter()
		dateFormatter.calendar = calender
		dateFormatter.dateFormat = "dd MMMM, YYYY"
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
#if APP
extension UIApplication {
	static var safeAreaInsets: UIEdgeInsets  {
		return UIApplication.shared.connectedScenes.compactMap{ ($0 as? UIWindowScene)?.keyWindow }.first!.safeAreaInsets
	}
}
#endif

public extension LocalizedStringKey {

	private typealias FArgs = (CVarArg, Formatter?)

	var localized: String? {
		let mirror = Mirror(reflecting: self)
		let key: String? = mirror.descendant("key") as? String
		
		guard let key else {
			return nil
		}
		
		var fargs: [FArgs] = []
		
		if let arguments = mirror.descendant("arguments") as? Array<Any> {
			for argument in arguments {
				let argumentMirror = Mirror(reflecting: argument)
				
				if let storage = argumentMirror.descendant("storage") {
					let storageMirror = Mirror(reflecting: storage)
					
					if let formatStyleValue = storageMirror.descendant("formatStyleValue") {
						let formatStyleValueMirror = Mirror(reflecting: formatStyleValue)

						guard var input = formatStyleValueMirror.descendant("input") as? CVarArg else {
							continue
						}
						
						let formatter: Formatter? = nil
						
						// TODO: Create relevant formatters
						if let _ = formatStyleValueMirror.descendant("format") {
							// Cast input to String
							input = String(describing: input) as CVarArg
						}
						
						fargs.append((input, formatter))
					} else if let storageValue = storageMirror.descendant("value") as? FArgs {
						fargs.append(storageValue)
					}
				}
			}
		}

		let string = NSLocalizedString(key, comment: "")
		
		if mirror.descendant("hasFormatting") as? Bool ?? false {
			return String.localizedStringWithFormat(
				string,
				fargs.map { arg, formatter in
					formatter?.string(for: arg) ?? arg
				}
			)
		} else {
			return string
		}
	}
	
	var localizedt: String? {
		let mirror = Mirror(reflecting: self)
		let key: String? = mirror.descendant("key") as? String
		
		guard let key else {
			return nil
		}
		
		var fargs: [FArgs] = []
		
		if let arguments = mirror.descendant("arguments") as? Array<Any> {
			for argument in arguments {
				let argumentMirror = Mirror(reflecting: argument)
				
				if let storage = argumentMirror.descendant("storage") {
					let storageMirror = Mirror(reflecting: storage)
					
					if let formatStyleValue = storageMirror.descendant("formatStyleValue") {
						let formatStyleValueMirror = Mirror(reflecting: formatStyleValue)

						guard var input = formatStyleValueMirror.descendant("input") as? CVarArg else {
							continue
						}
						
						let formatter: Formatter? = nil
						
						// TODO: Create relevant formatters
						if let _ = formatStyleValueMirror.descendant("format") {
							// Cast input to String
							input = String(describing: input) as CVarArg
						}
						
						fargs.append((input, formatter))
					} else if let storageValue = storageMirror.descendant("value") as? FArgs {
						fargs.append(storageValue)
					}
				}
			}
		}

		let string = NSLocalizedString(key, tableName: "LocalizableNames", comment: "")
		
		if mirror.descendant("hasFormatting") as? Bool ?? false {
			return String.localizedStringWithFormat(
				string,
				fargs.map { arg, formatter in
					formatter?.string(for: arg) ?? arg
				}
			)
		} else {
			return string
		}
	}
}
