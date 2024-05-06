import SwiftUI

struct AthanTimeTable: View {

	let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
	let prayer: PrayerTime?

	var body: some View {
		if prayer != nil {
			LazyVGrid(columns: gridItems, spacing: 0) {
				PrayerTimeTableItem(prayerName: LocalizedStringKey("ttFajr"), 	 prayerTime: prayer!.getStr(prayer: .fajr), 	prayerIcon: "ic_sun1")
				PrayerTimeTableItem(prayerName: LocalizedStringKey("ttSunrise"), prayerTime: prayer!.getStr(prayer: .sunrise), 	prayerIcon: "ic_sun2")
				PrayerTimeTableItem(prayerName: LocalizedStringKey("ttDhur"), 	 prayerTime: prayer!.getStr(prayer: .dhuhr), 	prayerIcon: "ic_sun3")
				PrayerTimeTableItem(prayerName: LocalizedStringKey("ttAsr"), 	 prayerTime: prayer!.getStr(prayer: .asr), 		prayerIcon: "ic_sun4")
				PrayerTimeTableItem(prayerName: LocalizedStringKey("ttMaghrib"), prayerTime: prayer!.getStr(prayer: .maghrib), 	prayerIcon: "ic_sun5")
				PrayerTimeTableItem(prayerName: LocalizedStringKey("ttIsha"), 	 prayerTime: prayer!.getStr(prayer: .isha),		prayerIcon: "ic_sun6")
			}
		}
	}
}

private struct PrayerTimeTableItem: View {

	let prayerName: LocalizedStringKey
	let prayerTime: String
	let prayerIcon: String
	@State var isPlayin = true

	var body: some View {
		VStack{
			VStack{
				ZStack{
					VStack(alignment: .center){
						Button(action: {
							isPlayin.toggle()
						}, label: {
							Image(prayerIcon)
								.resizable()
								.imageScale(.small)
								.frame(width: 38, height: 38)
								.foregroundColor(Color("cardView.title"))
								.padding(.bottom, 5)
						})
						Text(prayerTime)
							.font(.headline)
							.fontWeight(.bold)
						Text(prayerName)
							.font(.footnote)
							.opacity(0.8)

					}
				}
			}
			.padding()
		}
	}
}

#Preview(body: {
	AthanTimeTable(prayer: PrayerTime(city: "Berlin"))
})

#Preview(body: {
	PrayerTimeTableItem(prayerName: LocalizedStringKey("ttFajr"), prayerTime: "04:17:00", prayerIcon: "ic_sun3")
})
