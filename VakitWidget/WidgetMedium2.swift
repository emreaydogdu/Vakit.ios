import WidgetKit
import Adhan
import SwiftUI

struct Medium2Entry: TimelineEntry {
	let date: Date
	let prayer: PrayerTime
	let prayer2: PrayerTime
}

struct WidgetMedium2: Widget {
	let kind: String = "WidgetMedium2"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Medium2Provider()) { entry in
			Medium2EntryView(entry: entry)
				.containerBackground(Color("cardView.sub"), for: .widget)
		}
		.contentMarginsDisabled()
		.supportedFamilies([.systemMedium])
	}
}

struct Medium2EntryView : View {
	var entry: Medium2Provider.Entry
	
	var body: some View {
		GeometryReader(){ proxy in
			let (fajr, sunrise, dhuhr, asr, maghrib, isha, time) = getTimes(prayer: entry.prayer, prayer2: entry.prayer2)
			HStack(alignment: .top){
				VStack{
					Text("ISTANBUL")
						.font(.system(size: 14, weight: .bold, design: .default))
						.foregroundColor(Color.text)
						.frame(maxWidth: .infinity, alignment: .leading)
					Text("\(entry.date, style: .date)")
						.foregroundColor(Color.text)
						.font(.system(size: 14, weight: .regular, design: .default))
						.frame(maxWidth: .infinity, alignment: .leading)
					Text(Date().getHijriDate())
						.foregroundColor(Color.text)
						.font(.system(size: 14, weight: .regular, design: .default))
						.frame(maxWidth: .infinity, alignment: .leading)
					Spacer()
					Text("Vaktin Cikmasina")
						.foregroundColor(Color.text)
						.font(.system(size: 14, weight: .regular, design: .default))
						.frame(maxWidth: .infinity, alignment: .leading)
					Text("\(time, style: .timer)")
						.foregroundColor(Color.text)
						.font(.system(size: 14, weight: .regular).monospacedDigit())
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				VStack{
					entryView(prayer: entry.prayer, title: "ttFajr", 	icon: "ic_sun1", time: fajr)
					entryView(prayer: entry.prayer, title: "ttSunrise", icon: "ic_sun2", time: sunrise)
					entryView(prayer: entry.prayer, title: "ttDhur", 	icon: "ic_sun3", time: dhuhr)
					entryView(prayer: entry.prayer, title: "ttAsr", 	icon: "ic_sun4", time: asr)
					entryView(prayer: entry.prayer, title: "ttMaghrib", icon: "ic_sun5", time: maghrib)
					entryView(prayer: entry.prayer, title: "ttIsha", 	icon: "ic_sun6", time: isha)
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
		}
		.padding(16)
	}

	private struct entryView: View {
		let prayer: PrayerTime
		let title: String
		let icon: String
		let time: String

		var body: some View {
			HStack {
				let color = prayer.currentPrayer() == title ? Color.color3 : Color.text
				Image(icon)
					.resizable()
					.aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
					.foregroundColor(color)
					.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
				Text(LocalizedStringKey(title))
					.foregroundColor(color)
					.font(.system(size: 13, weight: .semibold, design: .default))
					.frame(maxWidth: .infinity, alignment: .leading)
				Text(time)
					.foregroundColor(color)
					.font(.system(size: 13, weight: .regular).monospacedDigit())
			}
		}
	}

	func getTimes(prayer: PrayerTime, prayer2: PrayerTime) -> (String, String, String, String, String, String, Date){
		var (fajr, sunrise, dhuhr, asr, maghrib, isha) = ("00:00", "00:00", "00:00", "00:00", "00:00", "00:00")

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
		return (fajr, sunrise, dhuhr, asr, maghrib, isha, Date())
	}
	
	func formattedPrayerTime(_ prayerTime: Date?) -> String {
		guard let prayerTime = prayerTime else { return "N/A" }

		let formatter = DateFormatter()
		formatter.timeStyle = .short
		formatter.timeZone = TimeZone.current

		return formatter.string(from: prayerTime)
	}
}

struct Medium2Provider: TimelineProvider {

	func placeholder(in context: Context) -> Medium2Entry {
		Medium2Entry(date: Date(), prayer: PrayerTime(city: "ISTANBUL"), prayer2: PrayerTime(city: "ISTANBUL"))
	}
	
	func getSnapshot(in context: Context, completion: @escaping (Medium2Entry) -> Void) {
		completion(Medium2Entry(date: Date(), prayer: PrayerTime(city: "ISTANBUL"), prayer2: PrayerTime(city: "ISTANBUL")))
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<Medium2Entry>) -> Void) {
		let prayer = PrayerTimesClass().decodePrayer(key: "prayerTimes1")
		let prayer2 = PrayerTimesClass().decodePrayer(key: "prayerTimes2")
		var entries: [Medium2Entry] = []

		let currentDate = Date().zeroSeconds
		for offset in 0 ..< 20 {
			let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
			entries.append(Medium2Entry(date: entryDate, prayer: prayer!, prayer2: prayer2!))
		}

		let timeline = Timeline( entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

#Preview(as: .systemMedium) {
	WidgetMedium2()
} timeline: {
	Medium2Entry(date: Date(), prayer: PrayerTime(city: "ISTANBUL"), prayer2: PrayerTime(city: "ISTANBUL"))
}
