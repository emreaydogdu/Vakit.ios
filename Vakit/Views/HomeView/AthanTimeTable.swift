import SwiftUI

struct AthanTimeTable: View {
	
	let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
	let prayer: PrayerTime?

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
				if prayer != nil {
					LazyVGrid(columns: gridItems, spacing: 0) {
						ForEach(0..<1) { _ in
							PrayerTimeTableItem(prayerName: LocalizedStringKey("ttFajr"), prayerTime: prayer!.getStr(prayer: .fajr), prayerIcon: "ic_sun1")
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.background(Color("cardView"))
							PrayerTimeTableItem(prayerName: LocalizedStringKey("ttSunrise"), prayerTime: prayer!.getStr(prayer: .sunrise), prayerIcon: "ic_sun2")
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.background(Color("cardView"))
							PrayerTimeTableItem(prayerName: LocalizedStringKey("ttDhur"), prayerTime: prayer!.getStr(prayer: .dhuhr), prayerIcon: "ic_sun3")
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.background(Color("cardView"))
							PrayerTimeTableItem(prayerName: LocalizedStringKey("ttAsr"), prayerTime: prayer!.getStr(prayer: .asr), prayerIcon: "ic_sun4")
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.background(Color("cardView"))
							PrayerTimeTableItem(prayerName: LocalizedStringKey("ttMaghrib"), prayerTime: prayer!.getStr(prayer: .maghrib), prayerIcon: "ic_sun5")
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.background(Color("cardView"))
							PrayerTimeTableItem(prayerName: LocalizedStringKey("ttIsha"), prayerTime: prayer!.getStr(prayer: .isha), prayerIcon: "ic_sun6")
								.frame(maxWidth: .infinity, maxHeight: .infinity)
								.background(Color("cardView"))
						}
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
		AthanTimeTable(prayer: nil)
	}
}
