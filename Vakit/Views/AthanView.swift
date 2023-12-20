import SwiftUI

struct AthanView: View {
	
	@ObservedObject var prayerClass: PrayerTimesClass
	@State private var isPresented = false
	@State private var isShowSettings = false
	
	var body: some View {
		NavigationView{
			ZStack{
				Color("bg").ignoresSafeArea()
				ScrollView{
					if let error = prayerClass.error {
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
				.navigationTitle("Athan")
				
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
		.preferredColorScheme(.dark)
}
