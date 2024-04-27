import WidgetKit
import Adhan
import SwiftUI

struct Medium2Entry: TimelineEntry {
	let date: Date
	let prayer: PrayerTime
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
			if entry.prayer != nil {
				let (fajr, sunrise, dhuhr, asr, maghrib, isha, time) = ("00:00", "00:00", "00:00", "00:00", "00:00", "00:00", Date())
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
						HStack {
							Image("ic_sun1")
								.resizable()
								.foregroundColor(entry.prayer.currentPrayer() == "ttFajr" ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttFajr"))
								.foregroundColor(entry.prayer.currentPrayer() == "ttFajr" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(fajr)
								.foregroundColor(entry.prayer.currentPrayer() == "ttFajr" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
						HStack {
							Image("ic_sun2")
								.resizable()
								.foregroundColor(entry.prayer.currentPrayer() == "ttSunrise" ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttSunrise"))
								.foregroundColor(entry.prayer.currentPrayer() == "ttSunrise" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(sunrise)
								.foregroundColor(entry.prayer.currentPrayer() == "ttSunrise" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
						HStack {
							Image("ic_sun3")
								.resizable()
								.foregroundColor(entry.prayer.currentPrayer() == "ttDhur" ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttDhur"))
								.foregroundColor(entry.prayer.currentPrayer() == "ttDhur" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(dhuhr)
								.foregroundColor(entry.prayer.currentPrayer() == "ttDhur" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
						HStack {
							Image("ic_sun4")
								.resizable()
								.foregroundColor(entry.prayer.currentPrayer() == "ttAsr" ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttAsr"))
								.foregroundColor(entry.prayer.currentPrayer() == "ttAsr" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(asr)
								.foregroundColor(entry.prayer.currentPrayer() == "ttAsr" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
						HStack {
							Image("ic_sun5")
								.resizable()
								.foregroundColor(entry.prayer.currentPrayer() == "ttMaghrib" ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttMaghrib"))
								.foregroundColor(entry.prayer.currentPrayer() == "ttMaghrib" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(maghrib)
								.foregroundColor(entry.prayer.currentPrayer() == "ttMaghrib" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
						HStack {
							Image("ic_sun6")
								.resizable()
								.aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
								.foregroundColor(entry.prayer.currentPrayer() == "ttIsha" ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttIsha"))
								.foregroundColor(entry.prayer.currentPrayer() == "ttIsha" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(isha)
								.foregroundColor(entry.prayer.currentPrayer() == "ttIsha" ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
					}
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
			}
		}
		.padding(16)
	}
}

struct Medium2Provider: TimelineProvider {

	func placeholder(in context: Context) -> Medium2Entry {
		Medium2Entry(date: Date(), prayer: PrayerTime(city: "ISTANBUL"))
	}
	
	func getSnapshot(in context: Context, completion: @escaping (Medium2Entry) -> Void) {
		completion(Medium2Entry(date: Date(), prayer: PrayerTime(city: "ISTANBUL")))
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<Medium2Entry>) -> Void) {
		let prayer = PrayerTimesClass().decodePrayer(key: "prayerTimes1")
		let prayer2 = PrayerTimesClass().decodePrayer(key: "prayerTimes2")
		var entries: [Medium2Entry] = []

		let currentDate = Date().zeroSeconds
		for offset in 0 ..< 20 {
			let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
			entries.append(Medium2Entry(date: entryDate, prayer: prayer!))
		}

		let timeline = Timeline( entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

#Preview(as: .systemMedium) {
	WidgetMedium2()
} timeline: {
	Medium2Entry(date: Date(), prayer: PrayerTime(city: "ISTANBUL"))
}
