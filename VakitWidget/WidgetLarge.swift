import WidgetKit
import SwiftUI

struct LargeEntry: TimelineEntry {
	let date: Date
	let text: String
}

struct WidgetLarge: Widget {
	let kind: String = "WidgetLarge"

	var body: some WidgetConfiguration {
		AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: LargeProvider()) { entry in
			LargeWidgetEntryView(entry: entry)
				.containerBackground(Color("cardView.sub"), for: .widget)
		}
		.contentMarginsDisabled()
		.supportedFamilies([.systemLarge])
	}
}

struct LargeWidgetEntryView : View {
	var entry: LargeProvider.Entry

	var body: some View {
		GeometryReader(){ proxy in
			Text("")
			  .font(.title)
			  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
			  .background(ContainerRelativeShape().fill(Color("cardView")))
			HStack{
				Text(entry.text)
					.bold()
				Image(systemName: "location.circle.fill")
					.foregroundColor(.white)
					.frame(alignment: .leading)
			}
			.padding(3)
			.padding(.horizontal, 6)
			.foregroundColor(.white)
			//.background(.black)
			.clipShape(.capsule)
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(5)
		}
		.padding(5)
		/*
		VStack {
			Text("Timeeee:")
			Text(entry.date, style: .time)

			Text("Favorite Emoji:")
			Text(entry.configuration.favoriteEmoji)
		}
		 */
	}
}

struct LargeProvider: AppIntentTimelineProvider {
	func placeholder(in context: Context) -> LargeEntry {
		LargeEntry(date: Date(), text: "Hello World")
	}

	func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> LargeEntry {
		LargeEntry(date: Date(), text: "Snapshot")
	}
	
	func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<LargeEntry> {
		var entries: [LargeEntry] = []

		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = LargeEntry(date: entryDate, text: "config")
			entries.append(entry)
		}

		return Timeline(entries: entries, policy: .atEnd)
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

#Preview(as: .systemLarge) {
	WidgetLarge()
} timeline: {
	LargeEntry(date: .now, text: "Hello World")
}
