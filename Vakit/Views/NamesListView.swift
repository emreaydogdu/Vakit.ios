import SwiftUI

struct NamesListView: View {
	
	@State private var offset = CGFloat.zero
	@State private var show = false
	@State private var title = String(localized: "Al-Asma-ul-Husna", table: "LocalizableNames")

	var body: some View {
		ZStack(alignment: .top){
			Background(pattern: false)
			OScrollView(scrollOffset: $offset) { _ in
				ForEach(0..<100){ idx in
					CardView(option: false) {
						ZStack {
							HStack{
								Spacer()
								VStack{
									ShareLink(item: "\(title)\n\n\(LocalizedStringKey(stringLiteral: "99namesAr\(idx)").localizedt!)\n\n\(LocalizedStringKey(stringLiteral: "99names\(idx)").localizedt!)\n\n\(LocalizedStringKey(stringLiteral: "99namesDesc\(idx)").localizedt!)") {
										Image("ic_share")
											.resizable()
											.imageScale(.small)
											.frame(width: 28, height: 28)
											.foregroundColor(Color("cardView.title"))
									}
									Spacer()
								}
							}
							VStack{
								Text(LocalizedStringKey(stringLiteral: "99namesAr\(idx)").localizedt!)
									.font(.title)
									.padding(.top, 12)
								Text(LocalizedStringKey(stringLiteral: "99names\(idx)").localizedt!)
									.fontWeight(.semibold)
									.foregroundColor(Color("textColor"))
									.frame(maxWidth: .infinity, alignment: .leading)
									.padding(.top, 2)
								Text(LocalizedStringKey(stringLiteral: "99namesDesc\(idx)").localizedt!)
									.font(.body)
									.foregroundColor(Color("subTextColor"))
									.frame(maxWidth: .infinity, alignment: .leading)
							}
						}
					}
				}
			}
			.onChange(of: offset) { show = offset.isLess(than: -60) ? false : true }
			.contentMargins(.top, 70, for: .scrollContent)
			ToolbarBck(title: String(localized: "Al-Asma-ul-Husna", table: "LocalizableNames"), show: $show)
		}
		.navigationBarBackButtonHidden(true)
	}
}

#Preview {
	NamesListView()
}
