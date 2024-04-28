import SwiftUI
import Request
import Json

struct DailyDuaView: View {
	
	@AppStorage("dailyCount")
	private var dailyCount = 1
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	@State var count = 0
	let title = LocalizedStringKey("Daily Ayah").localized!
	@State var dua = "The redacted view modifier is enabled on the first SwiftUI view, compared to an unredacted view at the bottom"
	@State var duaArab = "The redacted view modifier is enabled on the first SwiftUI view, compared to an unredacted view at the bottom"
	@State var chapter = "Al-Fatihah"
	
	
	var body: some View {
		CardView(option: false) {
			VStack{
				ShareLink(item: "\(title)\n\n\(dua.replacingOccurrences(of: "&quot;", with: "\""))\n\n\(duaArab)\n\n\(chapter)") {
					HStack {
						Text(title)
							.font(.headline)
							.fontWeight(.bold)
							.foregroundColor(Color("textColor"))
							.frame(maxWidth: .infinity, alignment: .leading)
							.task {
								dua = "The redacted view modifier is enabled on the first SwiftUI view, compared to an unredacted view at the bottom"
								duaArab = "The redacted view modifier is enabled on the first SwiftUI view, compared to an unredacted view at the bottom"
								chapter = "Al-Fatihah"
								(dua, duaArab, chapter) = await QuranApi().getDailyAyah()
							}
						Image("ic_share")
							.resizable()
							.imageScale(.small)
							.frame(width: 28, height: 28)
							.foregroundColor(Color("cardView.title"))
					}
				}
				Text(dua.replacingOccurrences(of: "&quot;", with: "\""))
					.font(.body)
					.foregroundColor(Color("subTextColor"))
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.top, 8)
					.padding(.bottom)
					.transition(.opacity)
					.redacted(reason: dua == "The redacted view modifier is enabled on the first SwiftUI view, compared to an unredacted view at the bottom" ? .placeholder : [])
					.id(dua)
				Text(duaArab.replacingOccurrences(of: "&quot;", with: "\""))
					.font(.body)
					.foregroundColor(Color("textColor"))
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.bottom)
					.transition(.opacity)
					.environment(\.layoutDirection, .rightToLeft)
					.redacted(reason: duaArab == "The redacted view modifier is enabled on the first SwiftUI view, compared to an unredacted view at the bottom" ? .placeholder : [])
					.id(duaArab)
				Text(chapter)
					.font(.headline)
					.foregroundColor(Color("textColor"))
					.fontWeight(.bold)
					.frame(maxWidth: .infinity, alignment: .leading)
					.onReceive(timer, perform: { time in
						count = Int.random(in: 1..<114)
					})
			}
		}
	}
	
}

#Preview {
	DailyDuaView()
}
