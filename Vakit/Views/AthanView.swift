import SwiftUI

struct AthanView: View {
	
	@ObservedObject var prayerClass: PrayerTimesClass
	@State private var isPresented = false
	@State private var isShowSettings = false
	
	@State var show = false
	@State private var defaultv: CGPoint = .zero
	@State private var scrollPosition: CGPoint = .zero
	
	var body: some View {
		NavigationView{
			ZStack (alignment: .top){
				Color("backgroundColor").ignoresSafeArea()
				Image("pattern")
					.frame(alignment: .top)
					.mask(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.15),  .black.opacity(0.1), .black.opacity(0)]), startPoint: .top, endPoint: .bottom))
					.opacity(0.9)
					.foregroundColor(Color("patternColor").opacity(0.4))
					.ignoresSafeArea()
				
				ScrollView(showsIndicators: false) {
					if prayerClass.error != nil {
						VStack{}
							.onAppear{
								//isPresented.toggle()
							}
					} else {
						if let prayers = prayerClass.prayers {
							if let nextPrayer = prayers.nextPrayer(){
								PrayerTimeHeader(prayerName: "\(nextPrayer)", prayerTime: prayers.time(for: nextPrayer), location: prayerClass.city ?? "__")
									.frame(maxWidth: .infinity, alignment: .center)
									.padding(.top, 100)
							} else if let prayers2 = prayerClass.prayers2 {
								if let nextPrayer2 = prayers2.nextPrayer(){
									PrayerTimeHeader(prayerName: "Imsak", prayerTime: prayers2.time(for: nextPrayer2), location: prayerClass.city ?? "__")
										.frame(maxWidth: .infinity, alignment: .center)
										.padding(.top, 100)
								} else {			
									PrayerTimeHeader(prayerName: "Imsak", prayerTime: Date(), location: prayerClass.city ?? "__")
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
									self.scrollPosition = value
									if (value.y < defaultv.y - 20.0){
										withAnimation(.linear(duration: 0.2)){
											show = true
										}
									} else {
										withAnimation(.easeOut(duration: 0.2)){
											show = false
										}
									}
								}
						}
						else {
							Text("No prayers")
						}
					}
				}
				.coordinateSpace(name: "scroll")
				.fullScreenCover(isPresented: $isPresented, content: { LocationNotFoundView() })
				.onAppear{
					prayerClass.startUpdatingLocation()
				}
				.onDisappear{
					prayerClass.stopUpdatingLocation()
				}
				TopView()
					.ignoresSafeArea()
				if (show){
					TopView()
						.background(BlurBG())
						.ignoresSafeArea()
						.onAppear{
							UIImpactFeedbackGenerator(style: .soft).impactOccurred()
						}
				}
			}
		}
	}
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
	static var defaultValue: CGPoint = .zero
	
	static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct TopView : View {
	
	var body: some View {
		
		HStack {
			VStack(alignment: .leading, spacing: 5) {
				Text(Date().getNavDate())
					.font(.custom("Fonts/Roboto-Medium", size: 20.0))
				Text(Date().getHijriDate())
					.font(.custom("Roboto-Light", size: 18.0))
			}
			Spacer(minLength: 0)
			Button(action: {}) {
				Text("Try")
					.foregroundColor(.white)
					.padding(.vertical,10)
					.padding(.horizontal, 25)
					.background(Color.blue)
					.clipShape(Capsule())
			}
		}
		// for non safe area phones padding will be 15...
		.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top == 0 ? 15 : (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 5)
		.padding(.horizontal)
		.padding(.bottom)
	}
}

struct BlurBG : UIViewRepresentable {
	func makeUIView(context: Context) -> UIVisualEffectView {
		let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
		return view
	}
	
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
	AthanView(prayerClass: PrayerTimesClass())
}
