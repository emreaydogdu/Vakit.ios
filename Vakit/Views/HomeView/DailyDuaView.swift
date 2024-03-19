import SwiftUI
import Request
import Json

struct DailyDuaView: View {
	
	@AppStorage("dailyCount")
	private var dailyCount = 1
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	@State var count = 0
	let title = NSLocalizedString("Daily Ayah", comment: "Describe what is being localized here")
	@State var dua = "The redacted view modifier is enabled on the first SwiftUI view, compared to an unredacted view at the bottom"
	@State var duaArab = "The redacted view modifier is enabled on the first SwiftUI view, compared to an unredacted view at the bottom"
	@State var chapter = "Al-Fatihah"
	
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(Color("cardView.sub"))
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.fill(Color("cardView"))
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
				.padding(5)
			VStack{
				ShareLink(item: "\(title)\n\n\(dua.replacingOccurrences(of: "&quot;", with: "\""))\n\n\(duaArab)\n\n\(chapter)") {
					HStack {
						Text(title)
							.font(.headline)
							.fontWeight(.bold)
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
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.top, 8)
					.padding(.bottom)
					.transition(.opacity)
					.redacted(reason: dua == "The redacted view modifier is enabled on the first SwiftUI view, compared to an unredacted view at the bottom" ? .placeholder : [])
					.id(dua)
				Text(duaArab.replacingOccurrences(of: "&quot;", with: "\""))
					.font(.body)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.bottom)
					.transition(.opacity)
					.environment(\.layoutDirection, .rightToLeft)
					.redacted(reason: duaArab == "The redacted view modifier is enabled on the first SwiftUI view, compared to an unredacted view at the bottom" ? .placeholder : [])
					.id(duaArab)
				Text(chapter)
					.font(.headline)
					.fontWeight(.bold)
					.frame(maxWidth: .infinity, alignment: .leading)
					.onReceive(timer, perform: { time in
						count = Int.random(in: 1..<114)
					})
			}
			.padding(22)
		}
	}
	
}

#Preview {
	DailyDuaView()
}
