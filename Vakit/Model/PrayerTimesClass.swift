import Adhan
import CoreLocation
import SwiftUI
import UserNotifications

struct PrayerTime: Codable {
	var id = UUID()
	let city: String
	let date: DateComponents?
	let fajr: Date?
	let sunrise: Date?
	let dhuhr: Date?
	let asr: Date?
	let maghrib: Date?
	let isha: Date?

	init(prayer: PrayerTimes?, city: String) {
		self.city = city
		self.date = prayer?.date
		self.fajr = prayer?.fajr
		self.sunrise = prayer?.sunrise
		self.dhuhr = prayer?.dhuhr
		self.asr = prayer?.asr
		self.maghrib = prayer?.maghrib
		self.isha = prayer?.isha
	}

	init(city: String) {
		self.city = city
		self.date = nil
		self.fajr = Date().tFajr
		self.sunrise = Date().tSunrise
		self.dhuhr = Date().tDhur
		self.asr = Date().tAsr
		self.maghrib = Date().tMaghrib
		self.isha = Date().tIsha
	}

	func getStr(prayer: Prayer) -> String
	{
		var str: Date?
		switch prayer {
		case .fajr:
			str = self.fajr
		case .sunrise:
			str = self.sunrise
		case .dhuhr:
			str = self.dhuhr
		case .asr:
			str = self.asr
		case .maghrib:
			str = self.maghrib
		case .isha:
			str = self.isha
		}
		return PrayerTimesClass().formattedPrayerTime(str)
	}    

	func currentPrayerDate(at time: Date = Date()) -> Date? {
		if self.isha!.timeIntervalSince(time) <= 0 {
			return self.isha
		} else if maghrib!.timeIntervalSince(time) <= 0 {
			return self.maghrib
		} else if asr!.timeIntervalSince(time) <= 0 {
			return self.asr
		} else if dhuhr!.timeIntervalSince(time) <= 0 {
			return self.dhuhr
		} else if sunrise!.timeIntervalSince(time) <= 0 {
			return self.sunrise
		} else if fajr!.timeIntervalSince(time) <= 0 {
			return self.fajr
		}
		return nil
	}
	public func nextPrayerDate(at time: Date = Date()) -> Date? {
		if isha!.timeIntervalSince(time) <= 0 {
			return nil
		} else if self.maghrib!.timeIntervalSince(time) <= 0 {
			return self.isha
		} else if self.asr!.timeIntervalSince(time) <= 0 {
			return self.maghrib
		} else if self.dhuhr!.timeIntervalSince(time) <= 0 {
			return self.asr
		} else if self.sunrise!.timeIntervalSince(time) <= 0 {
			return self.dhuhr
		} else if self.fajr!.timeIntervalSince(time) <= 0 {
			return self.sunrise
		}
		return self.fajr
	}

	func currentPrayer(at time: Date = Date()) -> String? {
		if self.isha!.timeIntervalSince(time) <= 0 {
			return "ttIsha"
		} else if maghrib!.timeIntervalSince(time) <= 0 {
			return "ttMaghrib"
		} else if asr!.timeIntervalSince(time) <= 0 {
			return "ttAsr"
		} else if dhuhr!.timeIntervalSince(time) <= 0 {
			return "ttDhur"
		} else if sunrise!.timeIntervalSince(time) <= 0 {
			return "ttSunrise"
		} else if fajr!.timeIntervalSince(time) <= 0 {
			return "ttFajr"
		}
		return "ttIsha"
	}

	public func nextPrayer(at time: Date = Date()) -> String? {
		if isha!.timeIntervalSince(time) <= 0 {
			return nil
		} else if maghrib!.timeIntervalSince(time) <= 0 {
			return "ttIsha"
		} else if asr!.timeIntervalSince(time) <= 0 {
			return "ttMaghrib"
		} else if dhuhr!.timeIntervalSince(time) <= 0 {
			return "ttAsr"
		} else if sunrise!.timeIntervalSince(time) <= 0 {
			return "ttDhur"
		} else if fajr!.timeIntervalSince(time) <= 0 {
			return "ttSunrise"
		}
		return "ttFajr"
	}
}

extension Date {
	static var yesterday: Date { return Date().dayBefore }
	static var tomorrow:  Date { return Date().dayAfter  }
	var dayBefore: Date {
		return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
	}
	var dayAfter: Date {
		return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
	}
	var noon: Date {
		return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
	}
	var month: Int {
		return Calendar.current.component(.month,  from: self)
	}
	var isLastDayOfMonth: Bool {
		return dayAfter.month != month
	}
	var zeroSeconds: Date {
		let calendar = Calendar.current
		let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
		return calendar.date(from: dateComponents)!
	}

	var tFajr:    Date { return Calendar.current.date(bySettingHour:  3, minute: 30, second: 0, of: self)! }
	var tSunrise: Date { return Calendar.current.date(bySettingHour:  5, minute: 30, second: 0, of: self)! }
	var tDhur: 	  Date { return Calendar.current.date(bySettingHour: 13, minute: 30, second: 0, of: self)! }
	var tAsr: 	  Date { return Calendar.current.date(bySettingHour: 17, minute: 30, second: 0, of: self)! }
	var tMaghrib: Date { return Calendar.current.date(bySettingHour: 20, minute: 30, second: 0, of: self)! }
	var tIsha:	  Date { return Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: self)! }
}

class PrayerTimesClass: NSObject, ObservableObject, CLLocationManagerDelegate {
	
	private let locationManager = CLLocationManager()
	private let gecoder = CLGeocoder()
	private let group = DispatchGroup()
	
	@Published var prayers: PrayerTimes?
	@Published var prayers2: PrayerTimes?
	@Published var error: Error?
	
	/*
	var notificationSettings: [String: Bool] = [
		"Fajr": true,
		"Dhuhr": true,
		"Asr": true,
		"Maghrib": true,
		"Isha": true
	]

	 private var notificationCenter: UNUserNotificationCenter {
		UNUserNotificationCenter.current()
	 }


	 func scheduleNotification(for prayerTime: Date, with prayerName: String) {
	 let content = UNMutableNotificationContent()

	 let prayerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: prayerTime)
	 let trigger = UNCalendarNotificationTrigger(dateMatching: prayerComponents, repeats: false)
	 let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

	 notificationCenter.add(request) { error in
	 if let error = error {
	 print("Error scheduling notification: \(error.localizedDescription)")
	 }
	 }
	 }

	 func schedulePrayerTimeNotifications() {
	 guard let prayers = prayers else {
	 print("Cannot schedule notifications because prayer times are not available yet.")
	 return
	 }

	 let prayerTimes = [
	 ("Fajr", prayers.fajr),
	 ("Dhuhr", prayers.dhuhr),
	 ("Asr", prayers.asr),
	 ("Maghrib", prayers.maghrib),
	 ("Isha", prayers.isha),
	 ]

	 notificationCenter.removeAllPendingNotificationRequests()
	 for (prayerName, prayerTime) in prayerTimes {
	 if notificationSettings[prayerName] == true {
	 scheduleNotification(for: prayerTime, with: prayerName)
	 }
	 }
	 }
	 func ubdateNotificationSettings(for prayerName: String, sendNotification: Bool){

	 notificationSettings[prayerName] = sendNotification
	 schedulePrayerTimeNotifications()

	 let defaults = UserDefaults(suiteName: "group.com.eaydgdu.vakit")
	 defaults?.set(notificationCenter, forKey: "notificationSettings")
	 }
	*/

	
	override init() {
		
		super.init()
		
		let defaults = UserDefaults(suiteName: "group.com.eaydgdu.vakit")
		/*
		if let savedSettings = defaults?.object(forKey: "notificationSettings") as? [String: Bool] {
			notificationSettings = savedSettings
		}
		*/
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		locationManager.requestWhenInUseAuthorization()
		/*
		notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if let error = error {
				print("Error requesting authorization for notifications: \(error.localizedDescription)")
			} else if granted {
				//print("User granted permission for notifications.")
			} else {
				print("User denied permission for notifications.")
			}
		}
		 */
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let tCalculation  = UserDefaults.standard.integer(forKey: "time_calculation")
		let tMadhab  = UserDefaults.standard.integer(forKey: "time_madhab")
		guard let location = locations.last else { return }
		
		var params: CalculationParameters
		let coordinates = Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		//let coordinates = Coordinates(latitude: 39.9300, longitude: 32.8500)
		let highLatRule = HighLatitudeRule.recommended(for: coordinates)

		switch tCalculation {
			case 0:
				params = CalculationMethod.turkey.params
			case 1:
				params = CalculationMethod.muslimWorldLeague.params
			case 2:
				params = CalculationMethod.egyptian.params
			case 3:
				params = CalculationMethod.karachi.params
			case 4:
				params = CalculationMethod.ummAlQura.params
			case 5:
				params = CalculationMethod.dubai.params
			case 6:
				params = CalculationMethod.qatar.params
			case 7:
				params = CalculationMethod.kuwait.params
			case 8:
				params = CalculationMethod.moonsightingCommittee.params
			case 9:
				params = CalculationMethod.singapore.params
			case 10:
				params = CalculationMethod.tehran.params
			case 11:
				params = CalculationMethod.northAmerica.params
			default:
			params = CalculationMethod.turkey.params
		}
		switch tMadhab {
			case 0:
				params.madhab = .shafi
			case 1:
				params.madhab = .hanafi
			default:
				params.madhab = .shafi
		}
		params.highLatitudeRule = highLatRule

		params.adjustments = PrayerAdjustments(fajr: UserDefaults.standard.integer(forKey: "time_shift_fajr"), sunrise: UserDefaults.standard.integer(forKey: "time_shift_sunrise"), dhuhr: UserDefaults.standard.integer(forKey: "time_shift_dhur"), asr: UserDefaults.standard.integer(forKey: "time_shift_asr"), maghrib: UserDefaults.standard.integer(forKey: "time_shift_maghrib"), isha: UserDefaults.standard.integer(forKey: "time_shift_isha"))
		let components = Calendar.current.dateComponents([.year, .month, .day], from: location.timestamp)
		let futureDate = Calendar.current.dateComponents([.year, .month, .day], from: Date.tomorrow)
		let prayerTimes = PrayerTimes(coordinates: coordinates, date: components, calculationParameters: params)
		let prayerTimes2 = PrayerTimes(coordinates: coordinates, date: futureDate, calculationParameters: params)

		DispatchQueue.main.async {
			self.prayers = prayerTimes
			self.prayers2 = prayerTimes2
			self.error = nil

			//self.schedulePrayerTimeNotifications()

		}
		gecoder.reverseGeocodeLocation(location) { placemarks, error in
			if let error = error {
				DispatchQueue.main.async {
					self.error = error
				}
			}else if let placemarks = placemarks? .first {
				DispatchQueue.main.async {
					
					let city = placemarks.locality ?? placemarks.administrativeArea ?? placemarks.country ?? "Unknown location"
					do {
						UserDefaults.standard.set(try JSONEncoder().encode(PrayerTime(prayer: prayerTimes, city: city)), forKey: "prayerTimes1")
						UserDefaults.standard.set(try JSONEncoder().encode(PrayerTime(prayer: prayerTimes2, city: city)), forKey: "prayerTimes2")
					} catch {
						print("Unable to Encode Note (\(error))")
					}
					self.group.leave()
				}
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		DispatchQueue.main.async {
			self.error = error
		}
	}
	
	func startUpdatingLocation(callback: (() -> Void)? = nil) {
		locationManager.delegate = self
		locationManager.startUpdatingLocation()
		group.enter()
		group.notify(queue: .main) {
			self.stopUpdatingLocation()
			callback!()
		}
	}
	
	func stopUpdatingLocation() {
		locationManager.stopUpdatingLocation()
	}

	func formattedPrayerTime(_ prayerTime: Date?) -> String {
		guard let prayerTime = prayerTime else { return "N/A" }
		
		let formatter = DateFormatter()
		formatter.timeStyle = .short
		formatter.timeZone = TimeZone.current
		
		return formatter.string(from: prayerTime)
	}
	


	func decodePrayer(key: String) -> PrayerTime?
	{
		if let data = UserDefaults.standard.data(forKey: key) {
			do {
				let prayer = try JSONDecoder().decode(PrayerTime.self, from: data)
				return prayer
			} catch {
				print("Unable to Decode Note (\(error))")
			}
		}
		return nil
	}
}
