import WidgetKit
import Adhan
import SwiftUI
import CoreLocation

struct SmallEntry: TimelineEntry {
	let date: Date
	let prayerClass: PrayerTimesClass
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
			if entry.prayerClass.error != nil { }
			else {
				let (fajr, sunrise, dhuhr, asr, maghrib, isha, prayer, _) = entry.prayerClass.getTimes(prayerClass: entry.prayerClass)
				VStack{
					Text(entry.prayerClass.city?.uppercased() ?? "ISTANBUL")
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
						let (a, b, c) = getNext3(prayer: prayer)
						let (d, e, f) = getNextTimes3(prayer: prayer)
						let (g, h, i) = getNextIcons3(prayer: prayer)
						HStack {
							Image(g)
								.resizable()
								.foregroundColor((prayer == .fajr || prayer == .asr) ? Color.color3 : Color.text)
								.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
							Text(a)
								.foregroundColor((prayer == .fajr || prayer == .asr) ? Color.color3 : Color.text)
								.font(.system(size: 14, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(d)
								.foregroundColor((prayer == .fajr || prayer == .asr) ? Color.color3 : Color.text)
								.font(.system(size: 14, weight: .medium).monospacedDigit())
						}
						HStack {
							Image(h)
								.resizable()
								.foregroundColor((prayer == .sunrise || prayer == .maghrib) ? Color.color3 : Color.text)
								.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
							Text(b)
								.foregroundColor((prayer == .sunrise || prayer == .maghrib) ? Color.color3 : Color.text)
								.font(.system(size: 14, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(e)
								.foregroundColor((prayer == .sunrise || prayer == .maghrib) ? Color.color3 : Color.text)
								.font(.system(size: 14, weight: .medium).monospacedDigit())
						}
						HStack {
							Image(i)
								.resizable()
								.foregroundColor((prayer == .dhuhr || prayer == .isha) ? Color.color3 : Color.text)
								.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
							Text(c)
								.foregroundColor((prayer == .dhuhr || prayer == .isha) ? Color.color3 : Color.text)
								.font(.system(size: 14, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(f)
								.foregroundColor((prayer == .dhuhr || prayer == .isha) ? Color.color3 : Color.text)
								.font(.system(size: 14, weight: .medium).monospacedDigit())
						}
					}
				}
			}
		}
		.padding(16)
	}
	
	func getNext3(prayer: Prayer) -> (LocalizedStringKey, LocalizedStringKey, LocalizedStringKey){
		switch prayer {
		case .fajr, .sunrise, .dhuhr:
			return (LocalizedStringKey("ttFajr"), LocalizedStringKey("ttSunrise"), LocalizedStringKey("ttDhur"))
		case .asr, .maghrib, .isha:
			return (LocalizedStringKey("ttAsr"), LocalizedStringKey("ttMaghrib"), LocalizedStringKey("ttIsha"))
		}
	}
	func getNextTimes3(prayer: Prayer) -> (String, String, String){
		switch prayer {
		case .fajr, .sunrise, .dhuhr:
			let fajr = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.fajr)
			let sunrise = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.sunrise)
			let dhur = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.dhuhr)
			return (fajr, sunrise, dhur)
		case .asr, .maghrib, .isha:
			let asr = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.asr)
			let magrhib = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.maghrib)
			let isha = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.isha)
			return (asr, magrhib, isha)
		}
	}
	func getNextIcons3(prayer: Prayer) -> (String, String, String){
		switch prayer {
		case .fajr, .sunrise, .dhuhr:
			return ("ic_sun1", "ic_sun2", "ic_sun3")
		case .asr, .maghrib, .isha:
			return ("ic_sun4", "ic_sun5", "ic_sun6")
		}
	}
}

struct SmallProvider: TimelineProvider {
	@ObservedObject var prayerClass = PrayerTimesClass()
	
	func placeholder(in context: Context) -> SmallEntry {
		SmallEntry(date: Date(), prayerClass: prayerClass)
	}
	
	func getSnapshot(in context: Context, completion: @escaping (SmallEntry) -> Void) {
		completion(SmallEntry(date: Date(), prayerClass: prayerClass))
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<SmallEntry>) -> Void) {
		var entries: [SmallEntry] = []
		
		prayerClass.startUpdatingLocation {
			let currentDate = Date().zeroSeconds
			for offset in 0 ..< 15 {
				let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
				entries.append(SmallEntry(date: entryDate, prayerClass: prayerClass))
			}
			
			let timeline = Timeline( entries: entries, policy: .atEnd)
			completion(timeline)
		}
	}
}

#Preview(as: .systemSmall) {
	WidgetSmall()
} timeline: {
	SmallEntry(date: .now, prayerClass: PrayerTimesClass())
}
