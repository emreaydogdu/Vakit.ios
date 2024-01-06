import SwiftUI

struct MainView: View {
	@State private var selectedTab = 0
	
	var body: some View {
		
		NavigationStack{
			TabView(selection: $selectedTab) {
				AthanView(prayerClass: PrayerTimesClass())
					.tabItem {
						Image("ic_home")
					}
					.tag(0)
				
				CompasView()
					.tabItem {
						Image("ic_compas")
					}
					.tag(1)
				
				MapView()
					.tabItem {
						Image("ic_marker_mosque")
					}
					.toolbar(.visible, for: .tabBar)
					.tag(2)
				
				MoreView(card: Card.example)
					.tabItem {
						Image("ic_menu")
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
