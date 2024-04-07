import WidgetKit
import SwiftUI

struct SmallEntry: TimelineEntry {
	let date: Date
	let text: String
}

struct WidgetSmall: Widget {
	let kind: String = "WidgetSmall"
	
	var body: some WidgetConfiguration {
		AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: SmallProvider()) { entry in
			SmallWidgetEntryView(entry: entry)
				.containerBackground(Color.cardViewSub, for: .widget)
		}
		//.contentMarginsDisabled()
		.supportedFamilies([.systemSmall])
	}
}

struct SmallWidgetEntryView : View {
	var entry: SmallProvider.Entry
	@ObservedObject var prayerClass = PrayerTimesClass()
	
	var body: some View {
		GeometryReader(){ proxy in
			if prayerClass.error != nil {
				Text("\(prayerClass.error ?? <#default value#>)")
					.foregroundColor(Color.text)
					.frame(maxWidth: .infinity, alignment: .leading)
			} else {
				if let prayers = prayerClass.prayers {
					
					if let nextPrayer = prayers.nextPrayer(){
						Text(prayerClass.city!)
							.foregroundColor(Color.text)
							.frame(maxWidth: .infinity, alignment: .leading)
					}
				}
			}
			VStack {
				Text("\(entry.date.addingTimeInterval(60), style: .timer)")
					.foregroundColor(Color.text)
					.frame(maxWidth: .infinity, alignment: .leading)
				Text("\(entry.text)")
					.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
		.padding(5)
	}
}

struct SmallProvider: AppIntentTimelineProvider {
	func placeholder(in context: Context) -> SmallEntry {
		SmallEntry(date: Date(), text: "Istanbul")
	}
	
	func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SmallEntry {
		SmallEntry(date: Date(), text: "Istanbul")
	}
	
	func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SmallEntry> {
		var entries: [SmallEntry] = []
		
		/*
		 if prayerClass.error != nil {
		 print("Hello")
		 entries.append(SmallEntry(date: Date(), text: "Failed"))
		 } else {
		 if let prayers = prayerClass.prayers {
		 if let nextPrayer = prayers.nextPrayer(){
		 entries.append(SmallEntry(date: prayers.time(for: nextPrayer), text: "Test"))
		 }
		 } else if let prayers2 = prayerClass.prayers2 {
		 if let nextPrayer2 = prayers2.nextPrayer(){
		 entries.append(SmallEntry(date: prayers2.time(for: nextPrayer2), text: "Test"))
		 } else {
		 entries.append(SmallEntry(date: Date(), text: "Test"))
		 }
		 }
		 }
		 */
		
		let currentDate = Date()
		let midnight = Calendar.current.startOfDay(for: currentDate)
		let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
		
		for offset in 0 ..< 60 * 24 {
			let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: midnight)!
			entries.append(SmallEntry(date: entryDate, text: "emre"))
		}
		
		return Timeline(entries: entries, policy: .after(nextMidnight))
	}
}

#Preview(as: .systemSmall) {
	WidgetSmall()
} timeline: {
	SmallEntry(date: .now, text: "Istanbul")
}
