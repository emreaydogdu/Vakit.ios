import SwiftUI
import SwiftData

@main
struct AthanApp: App {
	
	@AppStorage("themeMode")
	private var themeMode = "Auto"
	@AppStorage("today")
	private var today = Date()
	@AppStorage("dailyCount")
	private var dailyCount = 0

	init(){
		if (dailyCount == 0) {
			today = Date()
			dailyCount = Int.random(in: 1..<500)
		}
		if let diff = Calendar.current.dateComponents([.year, .month, .day, .minute, .second], from: today, to: Date()).day, diff != 0 {
			today = Date()
			dailyCount = Int.random(in: 1..<500)
		}
	}
	
	var body: some Scene {
		WindowGroup {
			MainView()
				.preferredColorScheme(themeMode == "Dark" ? .dark : themeMode == "Light" ? .light : nil)
		}
		.modelContainer(for: [Dhikr.self])
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
