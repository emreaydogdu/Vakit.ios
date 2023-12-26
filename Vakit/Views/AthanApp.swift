import SwiftUI

@main
struct AthanApp: App {
	
	@AppStorage("themeMode")
	private var themeMode = "Auto"

	var body: some Scene {
		WindowGroup {
			MainView()
				.preferredColorScheme(themeMode == "Dark" ? .dark : themeMode == "Light" ? .light : nil)
		}
	}
}
