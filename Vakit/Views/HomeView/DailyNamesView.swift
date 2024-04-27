import SwiftUI

struct DailyNamesView: View {
	
	@AppStorage("dailyCount")
	private var dailyCount = 0
	@State private var idx = 1
	@State private var title = String(localized: "Al-Asma-ul-Husna", table: "LocalizableNames")
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(.ultraThinMaterial)
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.fill(.regularMaterial)
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
				.padding(5)
			VStack{
				ShareLink(item: "\(title)\n\n\(LocalizedStringKey(stringLiteral: "99namesAr\(idx)").localizedt!)\n\n\(LocalizedStringKey(stringLiteral: "99names\(idx)").localizedt!)\n\n\(LocalizedStringKey(stringLiteral: "99namesDesc\(idx)").localizedt!)") {
					HStack {
						Text(title)
							.font(.headline)
							.fontWeight(.bold)
							.frame(maxWidth: .infinity, alignment: .leading)
							.task {
								idx = mod(dailyCount, 4)
							}
						Image("ic_share")
							.resizable()
							.imageScale(.small)
							.frame(width: 28, height: 28)
							.foregroundColor(Color("cardView.title"))
					}
				}
				Text(LocalizedStringKey(stringLiteral: "99namesAr\(idx)").localizedt!)
					.font(.title)
					.padding(.top, 8)
				Text(LocalizedStringKey(stringLiteral: "99names\(idx)").localizedt!)
					.fontWeight(.semibold)
					.foregroundColor(Color("textColor"))
					.frame(maxWidth: .infinity, alignment: .leading)
				Text(LocalizedStringKey(stringLiteral: "99namesDesc\(idx)").localizedt!)
					.font(.body)
					.foregroundColor(Color("subTextColor"))
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			.padding(22)
		}
	}
	
	func mod(_ a: Int, _ n: Int) -> Int {
		precondition(n > 0, "modulus must be positive")
		let r = a % n
		return r >= 0 ? r : r + n
	}
}

#Preview {
	DailyNamesView()
}
