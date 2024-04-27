import WidgetKit
import Adhan
import SwiftUI

struct MediumEntry: TimelineEntry {
	let date: Date
	let prayer: PrayerTime
	let prayer2: PrayerTime
}

struct WidgetMedium: Widget {
	let kind: String = "WidgetMedium"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: MediumProvider()) { entry in
			MediumWidgetEntryView(entry: entry)
				.containerBackground(Color("cardView.sub"), for: .widget)
		}
		.contentMarginsDisabled()
		.supportedFamilies([.systemMedium])
	}
}

struct MediumWidgetEntryView : View {
	var entry: MediumProvider.Entry
	
	var body: some View {
		GeometryReader(){ proxy in
			if entry.prayer != nil {
				let (fajr, sunrise, dhuhr, asr, maghrib, isha) = getTimes(prayer: entry.prayer, prayer2: entry.prayer2)
				VStack{
					HStack(alignment: .top){
						Text("ISTANBUL")
							.font(.system(size: 14, weight: .bold, design: .default))
							.foregroundColor(Color.text)
							.frame(maxWidth: .infinity, alignment: .leading)
						VStack {
							Text("\(entry.date, style: .date)")
								.foregroundColor(Color.text)
								.font(.system(size: 14, weight: .regular, design: .default))
								.frame(maxWidth: .infinity, alignment: .trailing)
							Text(Date().getHijriDate())
								.foregroundColor(Color.text)
								.font(.system(size: 14, weight: .regular, design: .default))
								.frame(maxWidth: .infinity, alignment: .trailing)
						}
					}
					Spacer()
					VStack{
						HStack(spacing: 55){
							VStack{
								HStack {
									Image("ic_sun1")
										.resizable()
										.foregroundColor(entry.prayer.currentPrayer() == "ttFajr" ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttFajr"))
										.foregroundColor(entry.prayer.currentPrayer() == "ttFajr" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(fajr)
										.foregroundColor(entry.prayer.currentPrayer() == "ttFajr" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image("ic_sun2")
										.resizable()
										.foregroundColor(entry.prayer.currentPrayer() == "ttSunrise" ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttSunrise"))
										.foregroundColor(entry.prayer.currentPrayer() == "ttSunrise" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(sunrise)
										.foregroundColor(entry.prayer.currentPrayer() == "ttSunrise" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image("ic_sun3")
										.resizable()
										.foregroundColor(entry.prayer.currentPrayer() == "ttDhur" ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttDhur"))
										.foregroundColor(entry.prayer.currentPrayer() == "ttDhur" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(dhuhr)
										.foregroundColor(entry.prayer.currentPrayer() == "ttDhur" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
							}
							VStack{
								HStack {
									Image("ic_sun4")
										.resizable()
										.foregroundColor(entry.prayer.currentPrayer() == "ttAsr" ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttAsr"))
										.foregroundColor(entry.prayer.currentPrayer() == "ttAsr" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(asr)
										.foregroundColor(entry.prayer.currentPrayer() == "ttAsr" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image("ic_sun5")
										.resizable()
										.foregroundColor(entry.prayer.currentPrayer() == "ttMaghrib" ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttMaghrib"))
										.foregroundColor(entry.prayer.currentPrayer() == "ttMaghrib" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(maghrib)
										.foregroundColor(entry.prayer.currentPrayer() == "ttMaghrib" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image("ic_sun6")
										.resizable()
										.foregroundColor(entry.prayer.currentPrayer() == "ttIsha" ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttIsha"))
										.foregroundColor(entry.prayer.currentPrayer() == "ttIsha" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(isha)
										.foregroundColor(entry.prayer.currentPrayer() == "ttIsha" ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
							}
						}
					}
				}
				.padding(16)
			}
		}
	}

	func getTimes(prayer: PrayerTime, prayer2: PrayerTime) -> (String, String, String, String, String, String){
		var (fajr, sunrise, dhuhr, asr, maghrib, isha) = ("00:00", "00:00", "00:00", "00:00", "00:00", "00:00")

		if prayer != nil {
			if prayer.nextPrayer() != nil {
				fajr = formattedPrayerTime(prayer.fajr)
				sunrise = formattedPrayerTime(prayer.sunrise)
				dhuhr = formattedPrayerTime(prayer.dhuhr)
				asr = formattedPrayerTime(prayer.asr)
				maghrib = formattedPrayerTime(prayer.maghrib)
				isha = formattedPrayerTime(prayer.isha)
			} else if prayer2.nextPrayer() != nil {
				fajr = formattedPrayerTime(prayer2.fajr)
				sunrise = formattedPrayerTime(prayer2.sunrise)
				dhuhr = formattedPrayerTime(prayer2.dhuhr)
				asr = formattedPrayerTime(prayer2.asr)
				maghrib = formattedPrayerTime(prayer2.maghrib)
				isha = formattedPrayerTime(prayer2.isha)
			}
		}
		return (fajr, sunrise, dhuhr, asr, maghrib, isha)
	}	

	func formattedPrayerTime(_ prayerTime: Date?) -> String {
		guard let prayerTime = prayerTime else { return "N/A" }

		let formatter = DateFormatter()
		formatter.timeStyle = .short
		formatter.timeZone = TimeZone.current

		return formatter.string(from: prayerTime)
	}
}

struct MediumProvider: TimelineProvider {
	
	func placeholder(in context: Context) -> MediumEntry {
		MediumEntry(date: Date(), prayer: PrayerTime(city: "ISTANBUL"), prayer2: PrayerTime(city: "ISTANBUL"))
	}
	
	func getSnapshot(in context: Context, completion: @escaping (MediumEntry) -> Void) {
		completion(MediumEntry(date: Date(), prayer: PrayerTime(city: "ISTANBUL"), prayer2: PrayerTime(city: "ISTANBUL")))
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<MediumEntry>) -> Void) {
		let prayer = PrayerTimesClass().decodePrayer(key: "prayerTimes1")
		let prayer2 = PrayerTimesClass().decodePrayer(key: "prayerTimes2")
		var entries: [MediumEntry] = []

		let currentDate = Date().zeroSeconds
		for offset in 0 ..< 15 {
			let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
			entries.append(MediumEntry(date: entryDate, prayer: prayer!, prayer2: prayer2!))
		}

		let timeline = Timeline( entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

#Preview(as: .systemMedium) {
	WidgetMedium()
} timeline: {
	MediumEntry(date: Date(), prayer: PrayerTime(city: "ISTANBUL"), prayer2: PrayerTime(city: "ISTANBUL"))
}
