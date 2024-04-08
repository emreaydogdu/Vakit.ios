import WidgetKit
import Adhan
import SwiftUI

struct MediumEntry: TimelineEntry {
	let date: Date
	let prayerClass: PrayerTimesClass
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
			if entry.prayerClass.error != nil { }
			else {
				let (fajr, sunrise, dhuhr, asr, maghrib, isha, prayer, _) = entry.prayerClass.getTimes(prayerClass: entry.prayerClass)
				VStack{
					HStack(alignment: .top){
						Text(entry.prayerClass.city?.uppercased() ?? "ISTANBUL")
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
										.foregroundColor((prayer == .fajr) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttFajr"))
										.foregroundColor((prayer == .fajr) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(fajr)
										.foregroundColor((prayer == .fajr) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image("ic_sun2")
										.resizable()
										.foregroundColor((prayer == .sunrise) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttSunrise"))
										.foregroundColor((prayer == .sunrise) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(sunrise)
										.foregroundColor((prayer == .sunrise) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image("ic_sun3")
										.resizable()
										.foregroundColor((prayer == .dhuhr) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttDhur"))
										.foregroundColor((prayer == .dhuhr) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(dhuhr)
										.foregroundColor((prayer == .dhuhr) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
							}
							VStack{
								HStack {
									Image("ic_sun4")
										.resizable()
										.foregroundColor((prayer == .asr) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttAsr"))
										.foregroundColor((prayer == .asr) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(asr)
										.foregroundColor((prayer == .asr) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image("ic_sun5")
										.resizable()
										.foregroundColor((prayer == .maghrib) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttMaghrib"))
										.foregroundColor((prayer == .maghrib) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(maghrib)
										.foregroundColor((prayer == .maghrib) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .medium, design: .default))
								}
								HStack {
									Image("ic_sun6")
										.resizable()
										.foregroundColor((prayer == .isha) ? Color.color3 : Color.text)
										.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
									Text(LocalizedStringKey("ttIsha"))
										.foregroundColor((prayer == .isha) ? Color.color3 : Color.text)
										.font(.system(size: 14, weight: .semibold, design: .default))
										.frame(maxWidth: .infinity, alignment: .leading)
									Text(isha)
										.foregroundColor((prayer == .isha) ? Color.color3 : Color.text)
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
}

struct MediumProvider: TimelineProvider {
	@ObservedObject var prayerClass = PrayerTimesClass()
	
	func placeholder(in context: Context) -> MediumEntry {
		MediumEntry(date: Date(), prayerClass: prayerClass)
	}
	
	func getSnapshot(in context: Context, completion: @escaping (MediumEntry) -> Void) {
		completion(MediumEntry(date: Date(), prayerClass: prayerClass))
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<MediumEntry>) -> Void) {
		var entries: [MediumEntry] = []
		
		print("getTimeline")
		prayerClass.startUpdatingLocation {
			let currentDate = Date().zeroSeconds
			for offset in 0 ..< 15 {
				let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
				entries.append(MediumEntry(date: entryDate, prayerClass: prayerClass))
			}
			
			let timeline = Timeline( entries: entries, policy: .atEnd)
			completion(timeline)
		}
	}
}


extension ConfigurationAppIntent {
	fileprivate static var smiley: ConfigurationAppIntent {
		let intent = ConfigurationAppIntent()
		intent.favoriteEmoji = "Hello"
		return intent
	}
	
	fileprivate static var starEyes: ConfigurationAppIntent {
		let intent = ConfigurationAppIntent()
		intent.favoriteEmoji = "Hello"
		return intent
	}
}

#Preview(as: .systemMedium) {
	WidgetMedium()
} timeline: {
	MediumEntry(date: Date(), prayerClass: PrayerTimesClass())
}
