import WidgetKit
import SwiftUI

@main
struct WidgetVakitBundle: WidgetBundle {
    var body: some Widget {
        WidgetSmall()
        WidgetMedium()
        WidgetLarge()
        WidgetLiveActivity()
    }
}
