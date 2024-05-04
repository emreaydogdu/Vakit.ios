import SwiftUI
import SwiftSoup
import Foundation

struct TestView: View {

	@AppStorage("themeMode")
	private var themeMode = "Auto"

	var body: some View {
		VStack {
			TestV()
			Picker("Theme", selection: $themeMode) {
				Text(LocalizedStringKey("Auto")).tag("Auto")
				Text(LocalizedStringKey("Light")).tag("Light")
				Text(LocalizedStringKey("Dark")).tag("Dark")
			}
			.pickerStyle(.segmented)
		}
	}
}

struct TestV: View {
	@Environment(\.colorScheme) var colorScheme

	var body: some View {
		Rectangle()
			.fill(getColorA())
			.frame(width: 100, height: 100)
	}

	func getColorA() -> Color {		
		switch colorScheme {
			case .light:
				return .red
			case .dark:
				return .blue
			default:
				return .green
		}
	}
}

#Preview {
	TestView()
}
