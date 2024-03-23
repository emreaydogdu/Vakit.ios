import SwiftUI

struct MoreView: View {
	@State private var hideTabBar = true
	
	var body: some View {
		NavigationView {
			ZStack(alignment: .top){
				PatternBG(pattern: true)
				ScrollView {
					ZStack {
						RoundedRectangle(cornerRadius: 25, style: .continuous)
							.fill(Color("cardView"))
							.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						VStack(spacing: 20){
							NavigationLink(destination: DhikrView()) {
								HStack{
									VStack{
										Text("Dhikr")
											.fontWeight(.bold)
											.frame(maxWidth: .infinity, alignment: .leading)
											.font(.headline)
											.foregroundColor(Color("cardView.title"))
											.multilineTextAlignment(.leading)
										Text("Daily dhikr routine after every Salah")
											.frame(maxWidth: .infinity, alignment: .leading)
											.font(.subheadline)
											.fontWeight(.semibold)
											.foregroundColor(Color("cardView.subtitle"))
											.multilineTextAlignment(.leading)
											.fixedSize(horizontal: false, vertical: true)
									}.padding(.trailing, 40)
									ZStack {
										RoundedRectangle(cornerRadius: 15, style: .continuous)
										 .fill(Color(hex: "#C9B3F4"))
										Image("ic_tasbih")
											.resizable()
											.frame(width: 28, height: 28)
									}.frame(width: 70, height: 70)
								}
							}
							Divider().frame(height: 2).overlay(Color("cardView.sub"))
							NavigationLink(destination: KazaView()) {
								HStack{
									VStack{
										Text("Missed prayers")
											.fontWeight(.bold)
											.frame(maxWidth: .infinity, alignment: .leading)
											.font(.headline)
											.foregroundColor(Color("cardView.title"))
											.multilineTextAlignment(.leading)
										Text("Keep track of your missed prayers")
											.frame(maxWidth: .infinity, alignment: .leading)
											.font(.subheadline)
											.fontWeight(.semibold)
											.foregroundColor(Color("cardView.subtitle"))
											.multilineTextAlignment(.leading)
											.fixedSize(horizontal: false, vertical: true)
									}.padding(.trailing, 40)
									ZStack {
										RoundedRectangle(cornerRadius: 15, style: .continuous)
										 .fill(Color(hex: "#B0DDF0"))
										Image("ic_kaza")
											.resizable()
											.frame(width: 28, height: 28)
									}.frame(width: 70, height: 70)
								}
							}
							Divider().frame(height: 2).overlay(Color("cardView.sub"))
							NavigationLink(destination: HolyDateView()) {
								HStack{
									VStack{
										Text("Holy Days")
											.fontWeight(.bold)
											.frame(maxWidth: .infinity, alignment: .leading)
											.font(.headline)
											.foregroundColor(Color("cardView.title"))
											.multilineTextAlignment(.leading)
										Text("Create, enable and use across your team")
											.frame(maxWidth: .infinity, alignment: .leading)
											.font(.subheadline)
											.fontWeight(.semibold)
											.foregroundColor(Color("cardView.subtitle"))
											.multilineTextAlignment(.leading)
											.fixedSize(horizontal: false, vertical: true)
									}.padding(.trailing, 40)
									ZStack {
										RoundedRectangle(cornerRadius: 15, style: .continuous)
											.fill(Color(hex: "#C6E7B8"))
											.frame(width: 70, height: 70)
										Image("ic_calendar")
										   .resizable()
										   .frame(width: 28, height: 28)
								   }.frame(width: 70, height: 70)
								}
							}
							Divider().frame(height: 2).overlay(Color("cardView.sub"))
							NavigationLink(destination: NamesListView()) {
								HStack{
									VStack{
										Text("Al-Asma-ul-Husna", tableName: "LocalizableNames")
											.fontWeight(.bold)
											.frame(maxWidth: .infinity, alignment: .leading)
											.font(.headline)
											.foregroundColor(Color("cardView.title"))
											.multilineTextAlignment(.leading)
										Text("Create, enable and use across your team")
											.frame(maxWidth: .infinity, alignment: .leading)
											.font(.subheadline)
											.fontWeight(.semibold)
											.foregroundColor(Color("cardView.subtitle"))
											.multilineTextAlignment(.leading)
											.fixedSize(horizontal: false, vertical: true)
									}.padding(.trailing, 40)
									ZStack {
										RoundedRectangle(cornerRadius: 15, style: .continuous)
											.fill(Color(hex: "#C6E7B8"))
											.frame(width: 70, height: 70)
										Image("ic_calendar")
										   .resizable()
										   .frame(width: 28, height: 28)
								   }.frame(width: 70, height: 70)
								}
							}
							Divider().frame(height: 4).overlay(Color("cardView.sub")).padding(.vertical)
							
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
						.padding()
						.multilineTextAlignment(.center)
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.padding()
				}
			}
			.navigationBarTitle("Discover more", displayMode: .large)
		}
	}
}

#Preview {
	MoreView()
}
