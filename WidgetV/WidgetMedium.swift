import WidgetKit
import Adhan
import SwiftUI

struct MediumEntry: TimelineEntry {
	let date: Date
	let prayerClass: PrayerTimesClass
	let city: String
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
			VStack{
				HStack(alignment: .top){
					Text(entry.prayerClass.city?.uppercased() ?? "__")
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
					if entry.prayerClass.error != nil {
						Text("Error:")
							.foregroundColor(Color.text)
							.frame(maxWidth: .infinity, alignment: .leading)
					} else {
						if let prayers = entry.prayerClass.prayers {
							if let nextPrayer = prayers.nextPrayer(){
								let fajr = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.fajr)
								let sunrise = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.sunrise)
								let dhur = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.dhuhr)
								let asr = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.asr)
								let magrhib = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.maghrib)
								let isha = entry.prayerClass.formattedPrayerTime(entry.prayerClass.prayers?.isha)
								HStack(spacing: 55){
									VStack{
										HStack {
											Image("ic_sun1")
												.resizable()
												.foregroundColor((nextPrayer == .fajr) ? Color.color3 : Color.text)
												.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
											Text(LocalizedStringKey("ttFajr"))
												.foregroundColor((nextPrayer == .fajr) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .semibold, design: .default))
												.frame(maxWidth: .infinity, alignment: .leading)
											Text(fajr)
												.foregroundColor((nextPrayer == .fajr) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .medium, design: .default))
										}
										HStack {
											Image("ic_sun2")
												.resizable()
												.foregroundColor((nextPrayer == .sunrise) ? Color.color3 : Color.text)
												.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
											Text(LocalizedStringKey("ttSunrise"))
												.foregroundColor((nextPrayer == .sunrise) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .semibold, design: .default))
												.frame(maxWidth: .infinity, alignment: .leading)
											Text(sunrise)
												.foregroundColor((nextPrayer == .sunrise) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .medium, design: .default))
										}
										HStack {
											Image("ic_sun3")
												.resizable()
												.foregroundColor((nextPrayer == .dhuhr) ? Color.color3 : Color.text)
												.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
											Text(LocalizedStringKey("ttDhur"))
												.foregroundColor((nextPrayer == .dhuhr) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .semibold, design: .default))
												.frame(maxWidth: .infinity, alignment: .leading)
											Text(dhur)
												.foregroundColor((nextPrayer == .dhuhr) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .medium, design: .default))
										}
									}
									VStack{
										HStack {
											Image("ic_sun4")
												.resizable()
												.foregroundColor((nextPrayer == .asr) ? Color.color3 : Color.text)
												.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
											Text(LocalizedStringKey("ttAsr"))
												.foregroundColor((nextPrayer == .asr) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .semibold, design: .default))
												.frame(maxWidth: .infinity, alignment: .leading)
											Text(asr)
												.foregroundColor((nextPrayer == .asr) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .medium, design: .default))
										}
										HStack {
											Image("ic_sun5")
												.resizable()
												.foregroundColor((nextPrayer == .maghrib) ? Color.color3 : Color.text)
												.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
											Text(LocalizedStringKey("ttMaghrib"))
												.foregroundColor((nextPrayer == .maghrib) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .semibold, design: .default))
												.frame(maxWidth: .infinity, alignment: .leading)
											Text(magrhib)
												.foregroundColor((nextPrayer == .maghrib) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .medium, design: .default))
										}
										HStack {
											Image("ic_sun6")
												.resizable()
												.foregroundColor((nextPrayer == .isha) ? Color.color3 : Color.text)
												.frame(maxWidth: 16, maxHeight: 16, alignment: .leading)
											Text(LocalizedStringKey("ttIsha"))
												.foregroundColor((nextPrayer == .isha) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .semibold, design: .default))
												.frame(maxWidth: .infinity, alignment: .leading)
											Text(isha)
												.foregroundColor((nextPrayer == .isha) ? Color.color3 : Color.text)
												.font(.system(size: 14, weight: .medium, design: .default))
										}
									}
								}
							}
						} else if let prayers2 = entry.prayerClass.prayers2 {
							if let nextPrayer2 = prayers2.nextPrayer(){
								
							} else {
								Text("Error")
									.foregroundColor(Color.text)
									.frame(maxWidth: .infinity, alignment: .leading)
							}
						} else { }
					}
				}
			}
		}
		.padding(16)
	}
}

struct MediumProvider: TimelineProvider {
	@ObservedObject var prayerClass = PrayerTimesClass()
	
	func placeholder(in context: Context) -> MediumEntry {
		MediumEntry(date: Date(), prayerClass: prayerClass, city: "Berlin")
	}
	
	func getSnapshot(in context: Context, completion: @escaping (MediumEntry) -> Void) {
		completion(MediumEntry(date: Date(), prayerClass: prayerClass, city: "Istanbul"))
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<MediumEntry>) -> Void) {
		var entries: [MediumEntry] = []
		
		print("getTimeline")
		prayerClass.startUpdatingLocation {
			let city = prayerClass.city
			
			print("callback")
			let currentDate = Date()
			for offset in 0 ..< 15 {
				let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
				entries.append(MediumEntry(date: entryDate, prayerClass: prayerClass, city: city ?? "__"))
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
	MediumEntry(date: Date(), prayerClass: PrayerTimesClass(), city: "Berlin")
}
