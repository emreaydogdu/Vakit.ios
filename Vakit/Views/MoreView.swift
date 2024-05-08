import SwiftUI

struct MoreView: View {

	@State private var offset = CGFloat.zero
	@State private var show = false

	var body: some View {
		NavigationView {
			ZStack(alignment: .top){
				Background(pattern: false)
				OScrollView(scrollOffset: $offset) { _ in
					CardView(option: false) {
						ZStack{
							RoundedRectangle(cornerRadius: 16, style: .continuous)
								.fill(Color(hex: "#433998"))
							Image("patternnn")
								.resizable()
								.aspectRatio(contentMode: .fill)
								.opacity(0.2)
								.clipped()
								.frame(maxWidth: .infinity, maxHeight: 120, alignment: .leading)
								.foregroundColor(Color(hex: "#233998"))
								.cornerRadius(16)
								.opacity(0)
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
									}.padding(.trailing, 40)
									ZStack {
										Image("ic_share")
											.resizable()
											.rotationEffect(.degrees(45))
											.foregroundColor(Color(hex: "#FDFDFF"))
											.frame(width: 38, height: 38)
									}.frame(width: 70, height: 70)
								}
							}
							.padding(15)
						}
						.padding(-22)

						ZStack{
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
												.fill(.thickMaterial)
											Image("ic_tasbih")
												.resizable()
												.frame(width: 38, height: 38)
										}.frame(width: 70, height: 70)
									}
								}
								Divider().frame(height: 2)
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
												.fill(.thickMaterial)
											Image("ic_kaza")
												.resizable()
												.frame(width: 38, height: 38)
										}.frame(width: 70, height: 70)
									}
								}
								Divider().frame(height: 2)
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
												.fill(.thickMaterial)
												.frame(width: 70, height: 70)
											Image("ic_calendar")
												.resizable()
												.frame(width: 38, height: 38)
										}.frame(width: 70, height: 70)
									}
								}
								Divider().frame(height: 2)
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
												.fill(.thickMaterial)
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
						.padding(-22)

						ZStack{
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
												.fill(.thickMaterial)
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
											.fill(.thickMaterial)
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
						.padding(-22)
					}
						.padding(.top, 70)
				}
				.onChange(of: offset) { show = offset.isLess(than: 30) ? false : true }

				Toolbar(title: "Discover more", show: $show)
			}
		}
	}
}

#Preview {
	MoreView()
}
