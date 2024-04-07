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
				.containerBackground(Color("cardView.sub"), for: .widget)
		}
		.contentMarginsDisabled()
		.supportedFamilies([.systemSmall])
	}
}

struct SmallWidgetEntryView : View {
	var entry: SmallProvider.Entry

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

struct SmallProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SmallEntry {
		SmallEntry(date: Date(), text: "Hello World")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SmallEntry {
		SmallEntry(date: Date(), text: "Snapshot")
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SmallEntry> {
        var entries: [SmallEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SmallEntry(date: entryDate, text: "config")
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

#Preview(as: .systemSmall) {
    WidgetSmall()
} timeline: {
	SmallEntry(date: .now, text: "Hello World")
}
