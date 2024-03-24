import SwiftUI

struct MoreView: View {
	@State private var hideTabBar = true
	@State private var show = false
	@State private var defaultv: CGPoint = .zero
	
	var body: some View {
		NavigationView {
			ZStack(alignment: .top){
				PatternBG(pattern: false)
				GeometryReader { geometry in
					ZStack(alignment: .top){
						PatternBG(pattern: false)
						ScrollView {
							ZStack {
								RoundedRectangle(cornerRadius: 20, style: .continuous)
									.fill(Color("cardView.sub"))
									.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
								VStack(spacing: 0){
									ZStack{
										RoundedRectangle(cornerRadius: 16, style: .continuous)
											.fill(Color(hex: "#433998"))
											.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
											.padding(5)
										Image("patternnn")
											.resizable()
											.aspectRatio(contentMode: .fill)
											.opacity(0.2)
											.clipped()
											.frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading)
											.foregroundColor(Color(hex: "#233998"))
											.cornerRadius(16)
											.padding(5)
										VStack(spacing: 20){
											NavigationLink(destination: DhikrView()) {
												HStack{
													VStack{
														Text("Upgrade to Unlock All Content")
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.headline)
															.fontWeight(.bold)
															.foregroundColor(Color(hex: "#FDFDFF"))
															.multilineTextAlignment(.leading)
														Text("Daily dhikr routine after every Salah")
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.body)
															.foregroundColor(Color(hex: "#FDFDFF"))
															.foregroundColor(Color("cardView.subtitle"))
															.multilineTextAlignment(.leading)
															.fixedSize(horizontal: false, vertical: true)
													}
													ZStack {
														Image("ic_share")
															.resizable()
															.rotationEffect(.degrees(45))
															.frame(width: 38, height: 38)
															.foregroundColor(Color(hex: "#FDFDFF"))
													}.frame(width: 70, height: 70)
												}
											}
										}
										.padding(22)
									}
									
									ZStack{
										RoundedRectangle(cornerRadius: 16, style: .continuous)
											.fill(Color("cardView"))
											.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
											.padding(5)
										VStack(spacing: 20){
											NavigationLink(destination: DhikrView()) {
												HStack{
													VStack{
														Text("Dhikr")
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.headline)
															.fontWeight(.bold)
															.foregroundColor(Color("textColor"))
															.multilineTextAlignment(.leading)
														Text("Daily dhikr routine after every Salah")
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.body)
															.foregroundColor(Color("subTextColor"))
															.multilineTextAlignment(.leading)
															.fixedSize(horizontal: false, vertical: true)
													}.padding(.trailing, 40)
													ZStack {
														RoundedRectangle(cornerRadius: 15, style: .continuous)
															.fill(Color("cardView.sub"))
														Image("ic_tasbih")
															.resizable()
															.frame(width: 38, height: 38)
													}.frame(width: 70, height: 70)
												}
											}
											Divider().frame(height: 2).overlay(Color("cardView.sub"))
											NavigationLink(destination: KazaView()) {
												HStack{
													VStack{
														Text("Missed prayers")
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.headline)
															.fontWeight(.bold)
															.foregroundColor(Color("textColor"))
															.multilineTextAlignment(.leading)
														Text("Keep track of your missed prayers")
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.body)
															.foregroundColor(Color("subTextColor"))
															.multilineTextAlignment(.leading)
															.fixedSize(horizontal: false, vertical: true)
													}.padding(.trailing, 40)
													ZStack {
														RoundedRectangle(cornerRadius: 15, style: .continuous)
															.fill(Color("cardView.sub"))
														Image("ic_kaza")
															.resizable()
															.frame(width: 38, height: 38)
													}.frame(width: 70, height: 70)
												}
											}
											Divider().frame(height: 2).overlay(Color("cardView.sub"))
											NavigationLink(destination: HolyDateView()) {
												HStack{
													VStack{
														Text("Holy Days")
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.headline)
															.fontWeight(.bold)
															.foregroundColor(Color("textColor"))
															.multilineTextAlignment(.leading)
														Text("Create, enable and use across your team")
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.body)
															.foregroundColor(Color("subTextColor"))
															.multilineTextAlignment(.leading)
															.fixedSize(horizontal: false, vertical: true)
													}.padding(.trailing, 40)
													ZStack {
														RoundedRectangle(cornerRadius: 15, style: .continuous)
															.fill(Color("cardView.sub"))
															.frame(width: 70, height: 70)
														Image("ic_calendar")
															.resizable()
															.frame(width: 38, height: 38)
													}.frame(width: 70, height: 70)
												}
											}
											Divider().frame(height: 2).overlay(Color("cardView.sub"))
											NavigationLink(destination: NamesListView()) {
												HStack{
													VStack{
														Text("Al-Asma-ul-Husna", tableName: "LocalizableNames")
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.headline)
															.fontWeight(.bold)
															.foregroundColor(Color("textColor"))
															.multilineTextAlignment(.leading)
														Text("Create, enable and use across your team")
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.body)
															.foregroundColor(Color("subTextColor"))
															.multilineTextAlignment(.leading)
															.fixedSize(horizontal: false, vertical: true)
													}.padding(.trailing, 40)
													ZStack {
														RoundedRectangle(cornerRadius: 15, style: .continuous)
															.fill(Color("cardView.sub"))
															.frame(width: 70, height: 70)
														Image("ic_99names")
															.resizable()
															.frame(width: 38, height: 38)
													}.frame(width: 70, height: 70)
												}
											}
										}
										.padding(22)
									}
									
									ZStack{
										RoundedRectangle(cornerRadius: 16, style: .continuous)
											.fill(Color("cardView"))
											.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
											.padding(5)
										
										VStack(spacing: 20){
											NavigationLink(destination: SettingsView()) {
												HStack{
													VStack{
														Text("Settings")
															.fontWeight(.bold)
															.frame(maxWidth: .infinity, alignment: .leading)
															.font(.headline)
															.foregroundColor(Color("cardView.title"))
															.multilineTextAlignment(.leading)
													}
													.padding(.trailing, 40)
													ZStack {
														RoundedRectangle(cornerRadius: 10, style: .continuous)
															.fill(Color("cardView.sub"))
															.frame(width: 40, height: 40)
														Image("ic_settings")
															.resizable()
															.frame(width: 24, height: 23)
															.foregroundColor(Color("cardView.title"))
													}
												}
											}
											HStack{
												VStack{
													Text("About")
														.fontWeight(.bold)
														.frame(maxWidth: .infinity, alignment: .leading)
														.font(.headline)
														.foregroundColor(Color("cardView.title"))
														.multilineTextAlignment(.leading)
												}
												.padding(.trailing, 40)
												ZStack {
													RoundedRectangle(cornerRadius: 10, style: .continuous)
														.fill(Color("cardView.sub"))
														.frame(width: 40, height: 40)
													Image("ic_about")
														.resizable()
														.frame(width: 24, height: 23)
														.foregroundColor(Color("cardView.title"))
												}
											}
										}
										.padding(22)
									}
								}
								.multilineTextAlignment(.center)
							}
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.padding()
							.background(GeometryReader { geometry in
								Color.clear
									.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
									.onAppear{
										defaultv = geometry.frame(in: .named("scroll")).origin
									}
							})
							.onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
								withAnimation(.linear(duration: 0.1)){
									show = value.y < defaultv.y - 30.0
								}
							}
							.padding(.top, 70)
							.scrollContentBackground(.hidden)
						}
						.coordinateSpace(name: "scroll")
					}
				}
				.background(.clear)
				ToolbarStd(title: "Discover more", show: $show)
			}
		}
	}
}

#Preview {
	MoreView()
}
