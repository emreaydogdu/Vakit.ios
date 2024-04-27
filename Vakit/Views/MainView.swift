import SwiftUI

struct MainView: View {
	@State private var selectedTab = 0

	var body: some View {
		NavigationStack{
			TabView(selection: $selectedTab) {
				AthanView()
					.tabItem {
						Image("ic_home")
					}
					.tag(0)

				TestView()
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
					.tag(2)

				MoreView()
					.tabItem {
						Image("ic_menu")
					}
					.tag(3)
			}
			.accentColor(Color("color"))
		}
		.overlay(SplashScreen())
	}
}

#Preview {
	MainView()
}
