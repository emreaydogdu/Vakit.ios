import Adhan
import CoreLocation
import SwiftUI
import UserNotifications

struct PrayerTime: Codable {
	let id = UUID()
	let date: DateComponents?
	let fajr: Date?
	let sunrise: Date?
	let dhuhr: Date?
	let asr: Date?
	let maghrib: Date?
	let isha: Date?

	init(prayer: PrayerTimes?) {
		self.date = prayer?.date
		self.fajr = prayer?.fajr
		self.sunrise = prayer?.sunrise
		self.dhuhr = prayer?.dhuhr
		self.asr = prayer?.asr
		self.maghrib = prayer?.maghrib
		self.isha = prayer?.isha
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
}

class PrayerTimesClass: NSObject, ObservableObject, CLLocationManagerDelegate {
	
	private let locationManager = CLLocationManager()
	private let gecoder = CLGeocoder()
	private let group = DispatchGroup()
	
	@Published var prayers: PrayerTimes?
	@Published var prayers2: PrayerTimes?
	@Published var city: String?
	@Published var error: Error?
	
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
	
	override init() {
		
		super.init()
		
		let defaults = UserDefaults(suiteName: "group.com.eaydgdu.vakit")
		if let savedSettings = defaults?.object(forKey: "notificationSettings") as? [String: Bool] {
			notificationSettings = savedSettings
		}
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		locationManager.requestWhenInUseAuthorization()
		
		notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			if let error = error {
				print("Error requesting authorization for notifications: \(error.localizedDescription)")
			} else if granted {
				//print("User granted permission for notifications.")
			} else {
				print("User denied permission for notifications.")
			}
		}
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

			self.schedulePrayerTimeNotifications()

			do {
				let prayer = PrayerTime(prayer: prayerTimes)
				let data = try JSONEncoder().encode(prayer)
				UserDefaults.standard.set(data, forKey: "prayerTimes1")
			} catch {
				print("Unable to Encode Note (\(error))")
			}
		}
		gecoder.reverseGeocodeLocation(location) { placemarks, error in
			if let error = error {
				DispatchQueue.main.async {
					self.error = error
				}
			}else if let placemarks = placemarks? .first {
				DispatchQueue.main.async {
					
					self.city = placemarks.locality ?? placemarks.administrativeArea ?? placemarks.country ?? "Unknown location"
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
	
	func getTimes(prayerClass: PrayerTimesClass) -> (String, String, String, String, String, String, Prayer, Date){
		var (fajr, sunrise, dhuhr, asr, maghrib, isha, time) = ("00:00", "00:00", "00:00", "00:00", "00:00", "00:00", Date())
		var prayer = Prayer.fajr
		
		if let prayer1 = prayers {
			if let nextPrayer = prayer1.nextPrayer() {
				prayer = nextPrayer
				time = prayer1.time(for: prayer)
				fajr = formattedPrayerTime(prayer1.fajr)
				sunrise = formattedPrayerTime(prayer1.sunrise)
				dhuhr = formattedPrayerTime(prayer1.dhuhr)
				asr = formattedPrayerTime(prayer1.asr)
				maghrib = formattedPrayerTime(prayer1.maghrib)
				isha = formattedPrayerTime(prayer1.isha)
			}
			else if let prayer2 = prayers2 {
				if let nextPrayer2 = prayer2.nextPrayer(){
					prayer = nextPrayer2
					time = prayer2.time(for: prayer)
					fajr = formattedPrayerTime(prayer2.fajr)
					sunrise = formattedPrayerTime(prayer2.sunrise)
					dhuhr = formattedPrayerTime(prayer2.dhuhr)
					asr = formattedPrayerTime(prayer2.asr)
					maghrib = formattedPrayerTime(prayer2.maghrib)
					isha = formattedPrayerTime(prayer2.isha)
				}
			}
		}
		return (fajr, sunrise, dhuhr, asr, maghrib, isha, prayer, time)
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
