//
//  WidgetVLiveActivity.swift
//  WidgetV
//
//  Created by Emre Aydogdu on 06.04.24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetVAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetVLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetVAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension WidgetVAttributes {
    fileprivate static var preview: WidgetVAttributes {
        WidgetVAttributes(name: "World")
    }
}

extension WidgetVAttributes.ContentState {
    fileprivate static var smiley: WidgetVAttributes.ContentState {
        WidgetVAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetVAttributes.ContentState {
         WidgetVAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WidgetVAttributes.preview) {
   WidgetVLiveActivity()
} contentStates: {
    WidgetVAttributes.ContentState.smiley
    WidgetVAttributes.ContentState.starEyes
}
