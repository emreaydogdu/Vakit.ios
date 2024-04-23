import SwiftUI

struct AthanTimeTable: View {
	
	let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
	let prayerClass: PrayerTimesClass
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(Color("cardView.sub"))
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.fill(Color("cardView"))
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
				.padding(5)
			VStack(alignment: .leading){
				LazyVGrid(columns: gridItems, spacing: 0) {
					ForEach(0..<1) { _ in
						PrayerTimeTableItem(prayerName: LocalizedStringKey("ttFajr"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.fajr.addingTimeInterval(UserDefaults.standard.double(forKey: "time_shift_fajr")*60)))", prayerIcon: "ic_sun1")
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.background(Color("cardView"))
						//.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						PrayerTimeTableItem(prayerName: LocalizedStringKey("ttSunrise"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.sunrise.addingTimeInterval(UserDefaults.standard.double(forKey: "time_shift_sunrise")*60)))", prayerIcon: "ic_sun2")
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.background(Color("cardView"))
						//.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						PrayerTimeTableItem(prayerName: LocalizedStringKey("ttDhur"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.dhuhr.addingTimeInterval(UserDefaults.standard.double(forKey: "time_shift_dhur")*60)))", prayerIcon: "ic_sun3")
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.background(Color("cardView"))
						//.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						PrayerTimeTableItem(prayerName: LocalizedStringKey("ttAsr"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.asr.addingTimeInterval(UserDefaults.standard.double(forKey: "time_shift_asr")*60)))", prayerIcon: "ic_sun4")
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.background(Color("cardView"))
						//.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						PrayerTimeTableItem(prayerName: LocalizedStringKey("ttMaghrib"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.maghrib.addingTimeInterval(UserDefaults.standard.double(forKey: "time_shift_maghrib")*60)))", prayerIcon: "ic_sun5")
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.background(Color("cardView"))
						//.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						PrayerTimeTableItem(prayerName: LocalizedStringKey("ttIsha"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.isha.addingTimeInterval(UserDefaults.standard.double(forKey: "time_shift_isha")*60)))", prayerIcon: "ic_sun6")
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.background(Color("cardView"))
						//.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
					}
				}
			}
			.cornerRadius(50)
			.padding(5)
		}
	}
}

struct AthanTimeTable_Previews: PreviewProvider {
	static var previews: some View {
		AthanTimeTable(prayerClass: PrayerTimesClass())
	}
}
