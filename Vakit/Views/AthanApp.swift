import SwiftUI
import SwiftData
import GoogleMobileAds

class AppDelegate: UIResponder, UIApplicationDelegate {
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		GADMobileAds.sharedInstance().start(completionHandler: nil)
		return true
	}
}

@main
struct AthanApp: App {
	
	@Environment(\.scenePhase) private var scenePhase
	var ad = AdsApi()
	
	@UIApplicationDelegateAdaptor(AppDelegate.self)
	var appDelegate
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
		.onChange(of: scenePhase) { phase in
			if phase == .active {
				ad.requestAppOpenAd()
			}
		}
		.modelContainer(for: [Dhikr.self])
	}
}
