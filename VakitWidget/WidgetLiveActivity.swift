import ActivityKit
import WidgetKit
import SwiftUI

 private struct BarProgressStyle: ProgressViewStyle {
	var height: Double = 16.0
	var labelFontStyle: Font = .body

	func makeBody(configuration: Configuration) -> some View {

		let progress = configuration.fractionCompleted ?? 0.0

		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Rectangle()
					.frame(width: geometry.size.width, height: height)
					.foregroundColor(Color(hex: "#39393D"))

				RoundedRectangle(cornerRadius: 10.0)
					.frame(width: geometry.size.width * progress, height: height)
					.foregroundColor(Color(hex: "#8E8E93"))
			}.cornerRadius(45.0)
		}
	}
}

struct LiveActivityAttr: ActivityAttributes {
	// Fixed non-changing properties about your activity go here!
	var title: String
	
	// Dynamic stateful properties about your activity go here!
    public struct ContentState: Codable, Hashable {
		var startTime: Date
    }
}

struct WidgetLiveActivity: Widget {
	let kind: String = "LiveActivity"
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttr.self) { context in
            VStack {
				Text("BERLIN")
					.font(.subheadline)
					.fontWeight(.bold)
					.frame(maxWidth: .infinity, alignment: .leading)
					.opacity(0.7)
				HStack{
					Image("ic_sun1")
						.resizable()
						.frame(maxWidth: 20, maxHeight: 20, alignment: .leading)
					Text("Ikindi")
						.font(.headline)
					 .fontWeight(.bold)
					Text("04:34")
						.font(.headline)
						.fontWeight(.bold)
						.foregroundColor(Color.color3)
					Spacer()
					Text("···")
						.font(.headline)
						.fontWeight(.bold)
						.opacity(0.5)
					Spacer()
					Text("05:16")
						.font(.headline)
						.fontWeight(.bold)
						.foregroundColor(Color.color3)
					Text("Yatsi")
						.font(.headline)
					 .fontWeight(.bold)
					Image("ic_sun2")
						.resizable()
						.frame(maxWidth: 20, maxHeight: 20, alignment: .leading)
				}
				HStack{
					Text("Current")
						.font(.caption2)
						.foregroundColor(Color.color3)
						.frame(maxWidth: .infinity, alignment: .leading)
					Spacer()
					Text("Next")
						.font(.caption2)
						.foregroundColor(Color.color3)
						.frame(maxWidth: .infinity, alignment: .trailing)
				}
				.padding(.bottom, 5 )
				ProgressView(value: 50, total: 100)
					.progressViewStyle(BarProgressStyle())
					.padding(.bottom, 8)
				HStack{
					Text("Vaktin cikmasina")
						.font(.footnote)
						.fontWeight(.semibold)
						.frame(maxWidth: .infinity, alignment: .leading)
					Spacer()
					//Text("\(context.state.startTime.addingTimeInterval(60*60*5), style: .relative)")
					Text("1h  15min")
						.font(.footnote)
						.fontWeight(.bold)
						.frame(maxWidth: .infinity, alignment: .trailing)
					Text("left")
						.font(.footnote)
						.fontWeight(.bold)
						.opacity(0.7)
				}

			}
			.padding()
			//.activityBackgroundTint(Color(hex: "#1C1C1E"))
            .activitySystemActionForegroundColor(Color.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
				DynamicIslandExpandedRegion(.center) {
                    Text("Center")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                }
            } compactLeading: {
				ZStack {
					Circle()
						.trim(from: 0, to: 1.0)
						.rotation(.degrees(-90))
						.stroke(Color.white.opacity(0.1), style: StrokeStyle(lineWidth: 3, lineCap: .round))
					.frame(width: 18, height: 18)
					Circle()
					 .trim(from: 0, to: 0.66)
					 .rotation(.degrees(-90))
					 .stroke(Color("color3"), style: StrokeStyle(lineWidth: 3, lineCap: .round))
					 .frame(width: 18, height: 18)
				}
            } compactTrailing: {
				Text("\(context.state.startTime, style: .time)")
            } minimal: {
				ZStack {
					Circle()
						.trim(from: 0, to: 1.0)
						.rotation(.degrees(-90))
						.stroke(Color.white.opacity(0.1), style: StrokeStyle(lineWidth: 3, lineCap: .round))
					.frame(width: 18, height: 18)
					Circle()
					 .trim(from: 0, to: 0.66)
					 .rotation(.degrees(-90))
					 .stroke(Color("color3"), style: StrokeStyle(lineWidth: 3, lineCap: .round))
					 .frame(width: 18, height: 18)
				}
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.cyan)
        }
	}
}

#Preview("Notification", as: .content, using: LiveActivityAttr(title: "World")) {
   WidgetLiveActivity()
} contentStates: {
	LiveActivityAttr.ContentState(startTime: .now)
}
#Preview("Notification", as: .dynamicIsland(.compact), using: LiveActivityAttr(title: "World")) {
   WidgetLiveActivity()
} contentStates: {
	LiveActivityAttr.ContentState(startTime: .now)
}
#Preview("Notification", as: .dynamicIsland(.expanded), using: LiveActivityAttr(title: "World")) {
   WidgetLiveActivity()
} contentStates: {
	LiveActivityAttr.ContentState(startTime: .now)
}
#Preview("Notification", as: .dynamicIsland(.minimal), using: LiveActivityAttr(title: "World")) {
   WidgetLiveActivity()
} contentStates: {
	LiveActivityAttr.ContentState(startTime: .now)
}
