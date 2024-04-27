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
				PatternBG(pattern: true)
				OScrollView(scrollOffset: $scrollOffset) { _ in
					if prayer != nil {
						if prayer!.nextPrayer() != nil {
							PrayerTimeHeader(prayer: prayer)
								.frame(maxWidth: .infinity, alignment: .center)
								.padding(.top, 80)
								.listRowSeparator(.hidden)
						} else if prayer2!.nextPrayer() != nil {
							Text("2")
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
						.padding(.horizontal)
						.padding(.bottom)
					NextHolyDayView()
						.padding(.horizontal)
						.padding(.bottom)
					DailyDuaView()
						.padding(.horizontal)
						.padding(.bottom, 50)
				}
				.onChange(of: scrollOffset) { show = scrollOffset.isLess(than: 30) ? false : true }
				.fullScreenCover(isPresented: $isPresented, content: { LocationNotFoundView() })
				.onAppear{

					print(prayer!.nextPrayer())
					print(prayer2!.nextPrayer())
					print(prayer2!.nextPrayerDate()!.formatted(date: .omitted, time: .shortened))
					print(prayer2!.isha!.timeIntervalSince(Date()))
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
				TopView(show: $show)
			}
		}
	}
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
	static var defaultValue: CGPoint = .zero
	
	static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

private struct TopView : View {
	
	@Binding var show: Bool
	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 5) {
				Text(Date().getNavDate())
					.font(.custom("Montserrat-Bold", size: 20.0))
				Text(Date().getHijriDate())
					.font(.custom("Montserrat-Medium", size: 18.0))
			}
			Spacer(minLength: 0)
			Button(action: {}) {
				Text("Try")
					.foregroundColor(.white)
					.padding(.vertical,10)
					.padding(.horizontal, 25)
					.background(Color("color"))
					.clipShape(Capsule())
			}
		}
		.padding(.top, UIApplication.safeAreaInsets.top == 0 ? 15 : UIApplication.safeAreaInsets.top + 5)
		.padding(.horizontal)
		.padding(.bottom)
		.background(show ? BlurBG() : nil)
		.onChange(of: show, { oldValue, newValue in
			UIImpactFeedbackGenerator(style: .soft).impactOccurred()
		})
		.ignoresSafeArea()
	}
}

#Preview {
	AthanView()
}
