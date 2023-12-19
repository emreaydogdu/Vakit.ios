import SwiftUI

struct MainView: View {
	@State private var selectedTab = 0
	
	var body: some View {
		TabView(selection: $selectedTab) {
			AthanView(prayerClass: PrayerTimesClass())
				.tabItem {
					Image(systemName: "clock.badge.fill")
					//Text("Athan Time")
				}
				.tag(0)
			
			CompasView()
				.tabItem {
					Image(systemName: "magnifyingglass")
					//Text("Qibla")
				}
				.tag(1)
			
			MapView()
				.tabItem {
					Image(systemName: "location.fill")
					//Text("Mosques")
				}
				.toolbar(.visible, for: .tabBar)
				.tag(2)
		}
		.accentColor(Color("color"))
	}
}

#Preview {
	MainView()
}
