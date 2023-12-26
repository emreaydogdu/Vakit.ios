import SwiftUI
import StoreKit

struct SettingsView: View {
	
	@Environment(\.requestReview) var requestReview
	
	@AppStorage("isNotificationsEnabled")
	private var isNotificationEnabled = true
	
	@AppStorage("themeMode")
	private var themeMode = "Auto"
	var themeModes = ["Auto", "Light", "Dark"]
	
	@State private var showLanguage = false
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Generally")) {
					Button("Language") {
						showLanguage.toggle()
					}
					.foregroundColor(Color("cardView.title"))
					.sheet(isPresented: $showLanguage) {
						LanguageSettingsView()
							.presentationDetents([.large])
							.presentationDragIndicator(.visible)
					}
				}
				
				Section(header: Text("Appereance")) {
					HStack(content: {
						Text("Theme")
							.foregroundColor(Color("cardView.title"))
						Spacer()
						Picker("Theme", selection: $themeMode) {
							ForEach(themeModes, id: \.self) {
								Text(LocalizedStringKey($0))
							}
						}
						.pickerStyle(.segmented)
						.fixedSize()
						.frame(alignment: .trailing)
					})
				}
				
				Section {
					Button("Review the app") {
						requestReview()
					}
					.foregroundColor(Color("cardView.title"))
					Button("Restore purchase") {
					}
					.foregroundColor(Color("cardView.title"))
				}
			}
			.scrollContentBackground(.hidden)
			.background(Color("backgroundColor"))
			.navigationBarTitle(Text("Settings"))
		}
	}
}

struct LanguageSettingsView: View {
	
	var languages = ["lc_en", "lc_de", "lc_tr"]
	var languagesd = ["lcd_en", "lcd_de", "lcd_tr"]
	var flags = ["en", "de", "tr"]
	
	var body: some View {
		NavigationView {
			ZStack {
				Color("backgroundColor").ignoresSafeArea()
				List {
					ForEach(languages.indices, id: \.self) { idx in
						HStack {
							Image(flags[idx])
								.resizable()
								.frame(width: 35, height: 35)
								.clipShape(Circle())

							VStack {
								Text(LocalizedStringKey(languagesd[idx]))
									.fontWeight(.bold)
									.frame(maxWidth: .infinity, alignment: .leading)
									.font(.subheadline)
									.foregroundColor(Color("cardView.title"))
									.multilineTextAlignment(.leading)
								Text(LocalizedStringKey(languages[idx]))
									.frame(maxWidth: .infinity, alignment: .leading)
									.font(.caption)
									.fontWeight(.semibold)
									.foregroundColor(Color("cardView.subtitle"))
									.multilineTextAlignment(.leading)
									.fixedSize(horizontal: false, vertical: true)
							}
							.padding(.leading, 10)
							
							Image(systemName: "checkmark")
								.resizable()
								.frame(width: 15, height: 15)
								.foregroundColor("lc_" + (Locale.current.language.languageCode?.identifier ?? "en") == languages[idx] ? .accentColor : .clear)
						}
						.padding(.vertical, 3)
					}
					.listRowBackground(Color("cardView"))
				}
				.onTapGesture {
					UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
				}
			}
			.navigationTitle("Languages")
		}
	}
}

#Preview {
	SettingsView()
}
