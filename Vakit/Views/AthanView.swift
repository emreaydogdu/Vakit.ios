import SwiftUI
import Adhan

struct AthanView: View {
	
	@ObservedObject var prayerClass: PrayerTimesClass
	@State private var isPresented = false
	@State private var isShowSettings = false
	
	@State var show = false
	@State private var defaultv: CGPoint = .zero
	
	var body: some View {
		NavigationView {
			ZStack (alignment: .top) {
				PatternBG(pattern: true)
				ScrollView(showsIndicators: false) {
					if prayerClass.error != nil {
						VStack{}
							.onAppear{
								//isPresented.toggle()
							}
					} else {
						if let prayers = prayerClass.prayers {
							//let currentPrayer = prayers.currentPrayer()
							if let nextPrayer = prayers.nextPrayer(){
								PrayerTimeHeader(prayerName: "\(nextPrayer)", nextPrayerName: "\(nextPrayer)", prayerTime: prayers.time(for: nextPrayer), location: prayerClass.city ?? "__")
									.frame(maxWidth: .infinity, alignment: .center)
									.padding(.top, 100)
							} else if let prayers2 = prayerClass.prayers2 {
								if let nextPrayer2 = prayers2.nextPrayer(){
									PrayerTimeHeader(prayerName: "Yatsi", nextPrayerName: "Imsak", prayerTime: prayers2.time(for: nextPrayer2), location: prayerClass.city ?? "__")
										.frame(maxWidth: .infinity, alignment: .center)
										.padding(.top, 100)
								} else {			
									PrayerTimeHeader(prayerName: "Yatsi", nextPrayerName: "Imsak", prayerTime: Date(), location: prayerClass.city ?? "__")
										.frame(maxWidth: .infinity, alignment: .center)
										.padding(.top, 100)
								}
							}
							AthanTimeTable(prayerClass: prayerClass)
								.padding()
								.listRowSeparator(.hidden)
								.onAppear {
									isPresented = false
								}
								.background(GeometryReader { geometry in
									Color.clear
										.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
										.onAppear{
											defaultv = geometry.frame(in: .named("scroll")).origin
										}
								})
								.onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
									withAnimation(.linear(duration: 0.2)){
										show = value.y < defaultv.y - 20.0
									}
								}
						}
						else {
							Text("No prayers")
						}
					}
					NextHolyDayView()
						.padding(.horizontal)
					DailyDuaView()
						.padding(.horizontal)
						.padding(.bottom, 50)
				}
				.coordinateSpace(name: "scroll")
				.fullScreenCover(isPresented: $isPresented, content: { LocationNotFoundView() })
				.onAppear{
					prayerClass.startUpdatingLocation()
				}
				.onDisappear{
					prayerClass.stopUpdatingLocation()
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
	AthanView(prayerClass: PrayerTimesClass())
}
