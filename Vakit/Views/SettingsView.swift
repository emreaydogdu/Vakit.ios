import SwiftUI
import StoreKit

struct SettingsView: View {
	
	@Environment(\.requestReview) var requestReview
	
	@AppStorage("isNotificationsEnabled")
	private var isNotificationEnabled = true
	
	@AppStorage("themeMode")
	private var themeMode = "Auto"

	@State private var showLanguage = false
	@State private var showCalculation = false
	@State private var scrollOffset = CGFloat.zero
	@State private var show = false

	var body: some View {
		ZStack(alignment: .top){
			Background(pattern: false)
			OScrollView(offset: $scrollOffset) { _ in
				ZStack {
					RoundedRectangle(cornerRadius: 20, style: .continuous)
						.fill(.clear)
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
					VStack{
						FormSection2(header: "Generally", footer: "An approximation of the Diyanet method used in Turkey. This approximation is less accurate outside the region of Turkey.", option: false) {
							HStack {
								Text("Language")
									.frame(maxWidth: .infinity, alignment: .leading)
									.foregroundColor(Color("cardView.title"))
									.sheet(isPresented: $showLanguage) { LanguageSettingsView() }
								Image(systemName: "chevron.right")
							}
							.contentShape(Rectangle())
							.onTapGesture { showLanguage.toggle() }

							HStack {
								Text("Calculation method")
									.frame(maxWidth: .infinity, alignment: .leading)
									.foregroundColor(Color("cardView.title"))
									.sheet(isPresented: $showCalculation) { CalculationSettingsView() }
								Image(systemName: "chevron.right")
							}
							.contentShape(Rectangle())
							.onTapGesture { showCalculation.toggle() }
						}

						FormSection2(header: "Appereance", footer: "", option: false) {
							HStack(content: {
								Text("Theme")
									.foregroundColor(Color("cardView.title"))
								Spacer()
								Picker("Theme", selection: $themeMode) {
									Text(LocalizedStringKey("Auto")).tag("Auto")
									Text(LocalizedStringKey("Light")).tag("Light")
									Text(LocalizedStringKey("Dark")).tag("Dark")
								}
								.pickerStyle(.segmented)
								.fixedSize()
								.frame(alignment: .trailing)
							})
						}

						FormSection2(header: "", footer: "", option: false) {
							Button("Review the app") { requestReview() }
								.frame(maxWidth: .infinity, alignment: .leading)
								.foregroundColor(Color("cardView.title"))
							Button("Restore purchase") { }
								.frame(maxWidth: .infinity, alignment: .leading)
								.foregroundColor(Color("cardView.title"))
						}
					}
				}
				.padding(.top, 70)
			}
			.onChange(of: scrollOffset) { show = scrollOffset.isLess(than: 30) ? false : true }

			ToolbarBck(title: "Settings", show: $show)
		}
		.navigationBarBackButtonHidden(true)
	}
}

struct LanguageSettingsView: View {
	
	var languages = ["lc_en", "lc_de", "lc_tr"]
	var languagesd = ["lcd_en", "lcd_de", "lcd_tr"]
	var flags = ["en", "de", "tr"]
	
	var body: some View {
		NavigationView {
			ZStack {
				Background(pattern: false)
				VStack {
					Capsule().fill(Color.red).frame(width: 35, height: 5).padding(.top, 12)
					Spacer()
				}
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

struct CalculationSettingsView: View {

	@State private var tCalculation  = UserDefaults.standard.integer(forKey: "time_calculation")
	@State private var tMahbab = UserDefaults.standard.integer(forKey: "time_madhab")
	@AppStorage("time_shift_fajr")		private var fajr = 0
	@AppStorage("time_shift_sunrise")	private var sunrise = 0
	@AppStorage("time_shift_dhur")		private var dhur 	= 0
	@AppStorage("time_shift_asr")		private var asr 	= 0
	@AppStorage("time_shift_maghrib")	private var maghrib = 0
	@AppStorage("time_shift_isha")		private var isha 	= 0

	var body: some View {
		ZStack {
			Background(pattern: false)
			ScrollView {
				VStack {
					Capsule().fill(Color.secondary).frame(width: 35, height: 5).padding(.top)
					FormSection2(header: "Calculation for different regions", footer: "An approximation of the Diyanet method used in Turkey. This approximation is less accurate outside the region of Turkey.", option: true) {
							HStack {
								Text("Method")
									.font(.headline)
									.fontWeight(.bold)
									.foregroundColor(Color("cardView.title"))
								Spacer()
								Picker("", selection: $tCalculation) {
									Text("Diyanet").tag(0)
									Text("Muslim World League").tag(1)
									Text("Egyptian General Authority of Survey").tag(2)
									Text("University of Islamic Sciences, Karachi").tag(3)
									Text("Umm al-Qura University, Makkah").tag(4)
									Text("UAE method").tag(5)
									Text("Qatar").tag(6)
									Text("Kuwait").tag(7)
									Text("Method developed by Khalid Shaukat").tag(8)
									Text("Singapore, Malaysia, and Indonesia").tag(9)
									Text("Institute of Geophysics, University of Tehran").tag(10)
									Text("North America, ISNA method").tag(11)
								}
								.onChange(of: tCalculation, { oldValue, newValue in
									UserDefaults.standard.set(tCalculation, forKey: "time_calculation")
								})
								.accentColor(.gray)
								.pickerStyle(.menu)
							}
					}

					FormSection2(header: "Madhab", footer: "Rule for calculating the time for Asr.\n**Shafi:** Earlier Asr time (Shafi, Maliki, Hanbali, Jafari)\n**Hanafi:** Later Asr time.", option: true) {
							HStack {
								Text("Rule")
									.font(.headline)
									.fontWeight(.bold)
									.foregroundColor(Color("cardView.title"))
								Spacer()
								Picker("", selection: $tMahbab) {
									Text("Shafi").tag(0)
									Text("Hanafi").tag(1)
								}
								.onChange(of: tMahbab, { oldValue, newValue in
									UserDefaults.standard.set(tMahbab, forKey: "time_madhab")
								})
								.accentColor(.gray)
								.pickerStyle(.menu)
							}
					}

					FormSection2(header: "Time correction", footer: "", option: false) {
						VStack {
							TimeShiftView(count: $fajr, 	name: "ttFajr")
							TimeShiftView(count: $sunrise, 	name: "ttSunrise")
							TimeShiftView(count: $dhur, 	name: "ttDhur")
							TimeShiftView(count: $asr, 		name: "ttAsr")
							TimeShiftView(count: $maghrib,	name: "ttMaghrib")
							TimeShiftView(count: $isha, 	name: "ttIsha")
						}
					}
				}
			}
		}
	}

	struct TimeShiftView : View {

		@Binding
		var count : Int
		var name  : LocalizedStringKey

		var body: some View {
			HStack {
				Text(name)
					.fontWeight(.bold)
					.font(.headline)
					.foregroundColor(Color("cardView.title"))
				Spacer()
				Text("\(count)")
					.fontWeight(.bold)
					.font(.title3)
					.padding(.trailing, 20)
				Stepper("", value: $count)
					.labelsHidden()
					.padding(.vertical, 8)
			}
		}
	}
}

struct FormSection2<Content: View>: View {
	let header: String
	let footer: String
	let option: Bool
	var content: Content

	init(header: String, footer: String, option: Bool, @ViewBuilder content: () -> Content) {
		self.content = content()
		self.option = option
		self.header = header
		self.footer = footer
	}

	var body: some View {
		_VariadicView.Tree(CardViewLayout(header: header, footer: footer, option: option)) {
			content
		}
	}
}

struct CardViewLayout: _VariadicView_UnaryViewRoot {
	let header: String
	let footer: String
	let option: Bool

	@ViewBuilder
	func body(children: _VariadicView.Children) -> some View {
		Section(
			header: Text("\(header)".uppercased())
				.font(.subheadline)
				.fontWeight(.bold)
				.foregroundColor(Color("cardView.title"))
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.leading, 38)
				.padding(.top, 20))
		{
			ZStack(alignment: .topLeading) {
				RoundedRectangle(cornerRadius: 20, style: .continuous)
					.fill(.ultraThinMaterial)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
				VStack(spacing: 0){
					ZStack{
						RoundedRectangle(cornerRadius: 16, style: .continuous)
							.fill(.regularMaterial)
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						VStack {
							ForEach(children.indices, id: \.self) { idx in
								children[idx]
									.padding()
								if (idx != children.count - 1){
									Divider()
								}
							}
						}
					}
					.padding([.leading, .top, .trailing, .bottom], 5)
					if(option){
						Text(.init("\(footer)"))
							.font(.subheadline)
							.opacity(0.8)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.horizontal, 18)
							.padding(.bottom, 10)
							.fixedSize(horizontal: false, vertical: true)
					}
				}
			}
			.padding(.horizontal)
		}
	}
}
#Preview {
	SettingsView()
}
