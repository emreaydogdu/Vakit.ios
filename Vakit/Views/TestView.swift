import SwiftUI
import SwiftSoup
import Foundation

struct TestView: View {

	var body: some View {
		VStack {
			Button(action: {
				let prayer = PrayerTimesClass().decodePrayer(key: "prayerTimes1")!
				print(prayer.getStr(prayer: .fajr))
			}, label: {
				Text("Press")
			})
		}
	}
}

#Preview {
	TestView()
}
