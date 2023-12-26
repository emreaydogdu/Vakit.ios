import SwiftUI

struct MainView: View {
	@State private var selectedTab = 3
	
	var body: some View {
		
		NavigationStack{
			TabView(selection: $selectedTab) {
				AthanView(prayerClass: PrayerTimesClass())
					.tabItem {
						Image(systemName: "house.fill")
						//Text("Athan Time")
					}
					.tag(0)
				
				CompasView()
					.tabItem {
						Image(systemName: "location.fill")
						//Text("Qibla")
					}
					.tag(1)
				
				MapView()
					.tabItem {
						Image(systemName: "mappin.and.ellipse")
						//Text("Mosques")
					}
					.toolbar(.visible, for: .tabBar)
					.tag(2)
				
				MoreView(card: Card.example)
					.tabItem {
						Image(systemName: "square.fill.on.circle.fill")
						//Text("Mosques")
					}
					.toolbar(.visible, for: .tabBar)
					.tag(3)
			}
			.accentColor(Color("color"))
		}
	}
}

#Preview {
	MainView()
}
