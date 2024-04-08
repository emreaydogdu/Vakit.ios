import WidgetKit
import Adhan
import SwiftUI

struct Medium2Entry: TimelineEntry {
	let date: Date
	let prayerClass: PrayerTimesClass
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
			if entry.prayerClass.error != nil { }
			else {
				let (fajr, sunrise, dhuhr, asr, maghrib, isha, prayer, time) = entry.prayerClass.getTimes(prayerClass: entry.prayerClass)
				HStack(alignment: .top){
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
								.foregroundColor((prayer == .fajr) ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttFajr"))
								.foregroundColor((prayer == .fajr) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(fajr)
								.foregroundColor((prayer == .fajr) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
						HStack {
							Image("ic_sun2")
								.resizable()
								.foregroundColor((prayer == .sunrise) ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttSunrise"))
								.foregroundColor((prayer == .sunrise) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(sunrise)
								.foregroundColor((prayer == .sunrise) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
						HStack {
							Image("ic_sun3")
								.resizable()
								.foregroundColor((prayer == .dhuhr) ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttDhur"))
								.foregroundColor((prayer == .dhuhr) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(dhuhr)
								.foregroundColor((prayer == .dhuhr) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
						HStack {
							Image("ic_sun4")
								.resizable()
								.foregroundColor((prayer == .asr) ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttAsr"))
								.foregroundColor((prayer == .asr) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(asr)
								.foregroundColor((prayer == .asr) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
						HStack {
							Image("ic_sun5")
								.resizable()
								.foregroundColor((prayer == .maghrib) ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttMaghrib"))
								.foregroundColor((prayer == .maghrib) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(maghrib)
								.foregroundColor((prayer == .maghrib) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .regular).monospacedDigit())
						}
						HStack {
							Image("ic_sun6")
								.resizable()
								.aspectRatio(1, contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
								.foregroundColor((prayer == .isha) ? Color.color3 : Color.text)
								.frame(maxWidth: 14, maxHeight: 14, alignment: .leading)
							Text(LocalizedStringKey("ttIsha"))
								.foregroundColor((prayer == .isha) ? Color.color3 : Color.text)
								.font(.system(size: 13, weight: .semibold, design: .default))
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(isha)
								.foregroundColor((prayer == .isha) ? Color.color3 : Color.text)
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
	@ObservedObject var prayerClass = PrayerTimesClass()
	
	func placeholder(in context: Context) -> Medium2Entry {
		Medium2Entry(date: Date(), prayerClass: prayerClass)
	}
	
	func getSnapshot(in context: Context, completion: @escaping (Medium2Entry) -> Void) {
		completion(Medium2Entry(date: Date(), prayerClass: prayerClass))
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<Medium2Entry>) -> Void) {
		var entries: [Medium2Entry] = []

		prayerClass.startUpdatingLocation {
			let currentDate = Date().zeroSeconds
			for offset in 0 ..< 20 {
				let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
				entries.append(Medium2Entry(date: entryDate, prayerClass: prayerClass))
			}
			
			let timeline = Timeline( entries: entries, policy: .atEnd)
			completion(timeline)
		}
	}
}

#Preview(as: .systemMedium) {
	WidgetMedium2()
} timeline: {
	Medium2Entry(date: Date(), prayerClass: PrayerTimesClass())
}
