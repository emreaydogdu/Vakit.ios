import WidgetKit
import Adhan
import SwiftUI
import CoreLocation

struct SmallEntry: TimelineEntry {
	let date: Date
	let prayerClass: PrayerTimesClass
	let city: String
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
				Text(entry.city.uppercased())//+" : "+entry.text)
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
					if entry.prayerClass.error != nil {
						Text("Error:")
							.foregroundColor(Color.text)
							.frame(maxWidth: .infinity, alignment: .leading)
					} else {
						if let prayers = entry.prayerClass.prayers {
							if let nextPrayer = prayers.nextPrayer(){
								let (a, b, c) = getNext3(prayer: nextPrayer)
								let (d, e, f) = getNextTimes3(prayer: nextPrayer)
								let (g, h, i) = getNextIcons3(prayer: nextPrayer)
								HStack {
									Image(g)
										.resizable()
										.foregroundColor((nextPrayer == .fajr || nextPrayer == .asr) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(a)
										.foregroundColor((nextPrayer == .fajr || nextPrayer == .asr) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(d)
										.foregroundColor((nextPrayer == .fajr || nextPrayer == .asr) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image(h)
										.resizable()
										.foregroundColor((nextPrayer == .sunrise || nextPrayer == .maghrib) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(b)
										.foregroundColor((nextPrayer == .sunrise || nextPrayer == .maghrib) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(e)
										.foregroundColor((nextPrayer == .sunrise || nextPrayer == .maghrib) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image(i)
										.resizable()
										.foregroundColor((nextPrayer == .dhuhr || nextPrayer == .isha) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(c)
										.foregroundColor((nextPrayer == .dhuhr || nextPrayer == .isha) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(f)
										.foregroundColor((nextPrayer == .dhuhr || nextPrayer == .isha) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
							}
						} else if let prayers2 = entry.prayerClass.prayers2 {
							if let nextPrayer2 = prayers2.nextPrayer(){
								let (a, b, c) = getNext3(prayer: nextPrayer2)
								let (d, e, f) = getNextTimes3(prayer: nextPrayer2)
								let (g, h, i) = getNextIcons3(prayer: nextPrayer2)
								HStack {
									Image(g)
										.resizable()
										.foregroundColor((nextPrayer2 == .fajr || nextPrayer2 == .asr) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(a)
										.foregroundColor((nextPrayer2 == .fajr || nextPrayer2 == .asr) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(d)
										.foregroundColor((nextPrayer2 == .fajr || nextPrayer2 == .asr) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image(h)
										.resizable()
										.foregroundColor((nextPrayer2 == .sunrise || nextPrayer2 == .maghrib) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(b)
										.foregroundColor((nextPrayer2 == .sunrise || nextPrayer2 == .maghrib) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(e)
										.foregroundColor((nextPrayer2 == .sunrise || nextPrayer2 == .maghrib) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image(i)
										.resizable()
										.foregroundColor((nextPrayer2 == .dhuhr || nextPrayer2 == .isha) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(c)
										.foregroundColor((nextPrayer2 == .dhuhr || nextPrayer2 == .isha) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(f)
										.foregroundColor((nextPrayer2 == .dhuhr || nextPrayer2 == .isha) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
							} else {
								Text("Error")
									.foregroundColor(Color.text)
									.frame(maxWidth: .infinity, alignment: .leading)
							}
						} else { }
					}
				}
				
			}
			.padding(11)
		}
		.padding(5)
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
		SmallEntry(date: Date(), prayerClass: prayerClass, city: "Berlin")
	}
	
	func getSnapshot(in context: Context, completion: @escaping (SmallEntry) -> Void) {
		completion(SmallEntry(date: Date(), prayerClass: prayerClass, city: "Istanbul"))
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<SmallEntry>) -> Void) {
		var entries: [SmallEntry] = []
		
		print("getTimeline")
		prayerClass.startUpdatingLocation {
			let city = prayerClass.city
			
			print("callback")
			let currentDate = Date()
			for offset in 0 ..< 15 {
				let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
				entries.append(SmallEntry(date: entryDate, prayerClass: prayerClass, city: city ?? "__"))
			}
			
			let timeline = Timeline( entries: entries, policy: .atEnd)
			completion(timeline)
		}
	}
}

#Preview(as: .systemSmall) {
	WidgetSmall()
} timeline: {
	SmallEntry(date: .now, prayerClass: PrayerTimesClass(), city: "Istanbul")
}
