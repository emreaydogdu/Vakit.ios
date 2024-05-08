import SwiftUI
import Adhan

struct AthanView: View {

	let prayer = PrayerTimesClass().decodePrayer(key: "prayerTimes1")
	let prayer2 = PrayerTimesClass().decodePrayer(key: "prayerTimes2")
	@State private var isPresented = false
	@State private var isShowSettings = false
	@State var scrollOffset = CGFloat.zero
	@State var show = false
	
	var body: some View {
		NavigationView {
			ZStack (alignment: .top) {
				Background(pattern: true)
				OScrollView(scrollOffset: $scrollOffset) { _ in
					if prayer != nil {
						if prayer!.nextPrayer() != nil {
							PrayerTimeHeader(prayer: prayer)
								.frame(maxWidth: .infinity, alignment: .center)
								.padding(.top, 80)
								.listRowSeparator(.hidden)
						} else if prayer2!.nextPrayer() != nil {
							PrayerTimeHeader(prayer: prayer2)
								.frame(maxWidth: .infinity , alignment: .center)
								.padding(.top, 80)
						}
					}
					else {
						Text("3")
						/*
						PrayerTimeHeader(prayer: PrayerTime(city: "__"))
							.frame(maxWidth: .infinity, alignment: .center)
							.padding(.top, 80)
							.onAppear {
								isPresented = false
							}
						 */
					}
					DailyNamesView()
					NextHolyDayView()
					DailyDuaView()
						.padding(.bottom, 50)
				}
				.onChange(of: scrollOffset) { show = scrollOffset.isLess(than: 30) ? false : true }
				.fullScreenCover(isPresented: $isPresented, content: { LocationNotFoundView() })
				.onAppear{
					/*
					prayerClass.startUpdatingLocation {
						print("hello")
					}
					 */
				}
				.onDisappear{
					/*
					prayerClass.stopUpdatingLocation()
					 */
				}
				ToolbarHome(show: $show)
			}
		}
	}
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
	static var defaultValue: CGPoint = .zero
	
	static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

#Preview {
	AthanView()
}
