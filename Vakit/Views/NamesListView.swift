import SwiftUI

struct NamesListView: View {
	
	@State private var show = false
	@State private var defaultv: CGPoint = .zero
	@State var title = String(localized: "Al-Asma-ul-Husna", table: "LocalizableNames")
	
	var body: some View {
		ZStack(alignment: .top){
			PatternBG(pattern: false)
			ScrollView {
				ForEach(0..<100){ idx in
					ZStack {
						RoundedRectangle(cornerRadius: 20, style: .continuous)
							.fill(Color("cardView.sub"))
							.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						RoundedRectangle(cornerRadius: 16, style: .continuous)
							.fill(Color("cardView"))
							.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
							.padding(5)
						HStack{
							Spacer()
							VStack{
								ShareLink(item: "\(title)\n\n\(LocalizedStringKey(stringLiteral: "99namesAr\(idx)").localizedt!)\n\n\(LocalizedStringKey(stringLiteral: "99names\(idx)").localizedt!)\n\n\(LocalizedStringKey(stringLiteral: "99namesDesc\(idx)").localizedt!)") {
									Image("ic_share")
										.resizable()
										.imageScale(.small)
										.frame(width: 28, height: 28)
										.foregroundColor(Color("cardView.title"))
										.padding()
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
						.padding(22)
					}
					.padding(.horizontal)
					.padding(.bottom, 6)
				}
				.background(GeometryReader { geometry in
					Color.clear
						.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
						.onAppear{
							defaultv = geometry.frame(in: .named("scroll")).origin
						}
				})
				.onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
					withAnimation(.linear(duration: 0.1)){
						show = value.y < defaultv.y - 10.0
					}
				}
			}
			.coordinateSpace(name: "scroll")
			.contentMargins(.top, 70, for: .scrollContent)
			ToolbarBck(title: String(localized: "Al-Asma-ul-Husna", table: "LocalizableNames"), show: $show)
		}
		.navigationBarBackButtonHidden(true)
	}
}

#Preview {
	NamesListView()
}
