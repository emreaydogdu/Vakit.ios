import ActivityKit
import WidgetKit
import SwiftUI

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
            // Lock screen/banner UI goes here
            VStack {
				Text("\(context.state.startTime.addingTimeInterval(60*60*5), style: .relative)")
					.font(.largeTitle)
					.fontWeight(.heavy)
					.frame(maxWidth: .infinity, alignment: .leading)
				HStack{
					Text("Ikindi")
					 .font(.title2)
					 .fontWeight(.bold)
					 .frame(maxWidth: .infinity, alignment: .leading)
					Spacer()
					Text("Yatsi")
						.font(.title2)
					 .fontWeight(.bold)
					 .frame(maxWidth: .infinity, alignment: .trailing)
				}
				.padding(.vertical)
				ProgressView(value: 0.5)
					.frame(height: 8.0)
					.scaleEffect(x: 1, y: 2, anchor: .center)
					.clipShape(RoundedRectangle(cornerRadius: 6))
					.tint(.white)
				
			}
			.padding()
            .activityBackgroundTint(Color.black)
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
