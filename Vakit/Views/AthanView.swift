import SwiftUI

struct AthanView: View {
	
	@ObservedObject var prayerClass: PrayerTimesClass
	@State private var isPresented = false
	@State private var isShowSettings = false
	
	var body: some View {
		NavigationView{
			ZStack (alignment: .top){
				Color("backgroundColor").ignoresSafeArea()
				Image("pattern")
					.frame(alignment: .top)
					.mask(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.15),  .black.opacity(0.1), .black.opacity(0)]), startPoint: .top, endPoint: .bottom))
					.opacity(0.6)
					.foregroundColor(Color("patternColor").opacity(0.4))
					.ignoresSafeArea()
				ScrollView{
					if prayerClass.error != nil {
						VStack{}
							.onAppear{
								isPresented = isPresented
							}
					} else {
						if let prayers = prayerClass.prayers {
							if let nextPrayer = prayers.nextPrayer(){
								PrayerTimeHeader(prayerName: "\(nextPrayer)", prayerTime: prayers.time(for: nextPrayer), location: prayerClass.city ?? "__")
									.frame(maxWidth: .infinity, alignment: .center)
							} else {
								PrayerTimeHeader(prayerName: "Imsak", prayerTime: Date(), location: prayerClass.city ?? "__")
									.frame(maxWidth: .infinity, alignment: .center)
							}
							AthanTimeTable(prayerClass: prayerClass)
								.padding()
								.listRowSeparator(.hidden)
								.onAppear {
									isPresented = false
								}
						}
					}
				}
				.navigationTitle("Hello")
				
				.fullScreenCover(isPresented: $isPresented, content: { LocationNotFoundView() })
				
				.onAppear{
					prayerClass.startUpdatingLocation()
				}
				.onDisappear{
					prayerClass.stopUpdatingLocation()
				}
			}
		}
	}
}

#Preview {
	AthanView(prayerClass: PrayerTimesClass())
}
