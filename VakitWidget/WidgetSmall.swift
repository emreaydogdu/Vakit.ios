import WidgetKit
import Adhan
import SwiftUI
import CoreLocation

struct SmallEntry: TimelineEntry {
	let date: Date
	let prayer: PrayerTime
}

struct WidgetSmall: Widget {
	let kind: String = "WidgetSmall"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: SmallProvider()) { entry in
			SmallWidgetEntryView(entry: entry)
				.containerBackground(Color.cardViewSub, for: .widget)
		}
		.contentMarginsDisabled()
		.supportedFamilies([.systemSmall])
	}
}

struct SmallWidgetEntryView : View {
	var entry: SmallProvider.Entry
	
	var body: some View {
		GeometryReader(){ proxy in
			VStack{
				Text(entry.prayer.city)
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
				VStack{
					let (a, b, c) = getNames(prayer: entry.prayer)
					let (d, e, f) = getTimes(prayer: entry.prayer)
					let (g, h, i) = getIcons(prayer: entry.prayer)
					HStack {
						let color = (entry.prayer.currentPrayer() == "ttFajr" || entry.prayer.currentPrayer() == "ttAsr") ? Color.color3 : Color.text
						Image(g)
							.resizable()
							.foregroundColor(color)
							.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
						Text(a)
							.foregroundColor(color)
							.font(.system(size: 14, weight: .semibold, design: .default))
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(d)
							.foregroundColor(color)
							.font(.system(size: 14, weight: .medium).monospacedDigit())
					}
					HStack {
						let color = (entry.prayer.currentPrayer() == "ttSunrise" || entry.prayer.currentPrayer() == "ttMaghrib") ? Color.color3 : Color.text
						Image(h)
							.resizable()
							.foregroundColor(color)
							.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
						Text(b)
							.foregroundColor(color)
							.font(.system(size: 14, weight: .semibold, design: .default))
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(e)
							.foregroundColor(color)
							.font(.system(size: 14, weight: .medium).monospacedDigit())
					}
					HStack {
						let color = (entry.prayer.currentPrayer() == "ttDhur" || entry.prayer.currentPrayer() == "ttIsha") ? Color.color3 : Color.text
						Image(i)
							.resizable()
							.foregroundColor(color)
							.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
						Text(c)
							.foregroundColor(color)
							.font(.system(size: 14, weight: .semibold, design: .default))
							.frame(maxWidth: .infinity, alignment: .leading)
						Text(f)
							.foregroundColor(color)
							.font(.system(size: 14, weight: .medium).monospacedDigit())
					}
				}
			}
		}
		.padding(16)
	}
	
	func getNames(prayer: PrayerTime) -> (LocalizedStringKey, LocalizedStringKey, LocalizedStringKey){
		switch prayer.currentPrayer()! {
		case "ttFajr", "ttSunrise", "ttDhur":
			return (LocalizedStringKey("ttFajr"), LocalizedStringKey("ttSunrise"), LocalizedStringKey("ttDhur"))
		case "ttAsr", "ttMaghrib", "ttIsha":
			return (LocalizedStringKey("ttAsr"), LocalizedStringKey("ttMaghrib"), LocalizedStringKey("ttIsha"))
		default:
			return ((""), (""), (""))
		}
	}
	func getTimes(prayer: PrayerTime) -> (String, String, String){
		switch prayer.currentPrayer()! {
		case "ttFajr", "ttSunrise", "ttDhur":
			let fajr = prayer.nextPrayerDate(at: prayer.fajr!)!.formatted(date: .omitted, time: .shortened)
			let sunrise = prayer.nextPrayerDate(at: prayer.sunrise!)!.formatted(date: .omitted, time: .shortened)
			let dhur = prayer.nextPrayerDate(at: prayer.dhuhr!)!.formatted(date: .omitted, time: .shortened)
			return ((fajr), (sunrise), (dhur))
		case "ttAsr", "ttMaghrib", "ttIsha":
			let asr = prayer.nextPrayerDate(at: prayer.asr!)!.formatted(date: .omitted, time: .shortened)
			let magrhib = prayer.nextPrayerDate(at: prayer.maghrib!)!.formatted(date: .omitted, time: .shortened)
			let isha = prayer.nextPrayerDate(at: prayer.isha!)!.formatted(date: .omitted, time: .shortened)
			return ((asr), (magrhib), (isha))
		default:
			return ((""), (""), (""))
		}
	}
	func getIcons(prayer: PrayerTime) -> (String, String, String){
		switch prayer.currentPrayer()! {
		case "ttFajr", "ttSunrise", "ttDhur":
			return ("ic_sun1", "ic_sun2", "ic_sun3")
		case "ttAsr", "ttMaghrib", "ttIsha":
			return ("ic_sun4", "ic_sun5", "ic_sun6")
		default:
			return ("ic_sun1", "ic_sun2", "ic_sun3")
		}
	}
}

struct SmallProvider: TimelineProvider {
	
	func placeholder(in context: Context) -> SmallEntry {
		SmallEntry(date: Date(), prayer: PrayerTime(city: "ISTANBUL"))
	}
	
	func getSnapshot(in context: Context, completion: @escaping (SmallEntry) -> Void) {
		completion(SmallEntry(date: Date(), prayer: PrayerTime(city: "ISTANBUL")))
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<SmallEntry>) -> Void) {
		let prayer = PrayerTimesClass().decodePrayer(key: "prayerTimes1")
		var entries: [SmallEntry] = []

		let currentDate = Date().zeroSeconds
		for offset in 0 ..< 15 {
			let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
			entries.append(SmallEntry(date: entryDate, prayer: prayer!))
		}

		let timeline = Timeline( entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

#Preview(as: .systemSmall) {
	WidgetSmall()
} timeline: {
	SmallEntry(date: .now, prayer: PrayerTime(city: "ISTANBUL"))
}
