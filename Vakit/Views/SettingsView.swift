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
	@State private var showCalculation = false
	@State private var scrollOffset = CGFloat.zero
	@State private var show = false

	var body: some View {
		ZStack(alignment: .top){
			PatternBG(pattern: false)
			OScrollView(scrollOffset: $scrollOffset) { _ in
				Form {
					Section{
						Button("Language") {
							showLanguage.toggle()
						}
						.foregroundColor(Color("cardView.title"))
						.sheet(isPresented: $showLanguage) {
							LanguageSettingsView()
						}
					} header: {
						Text("Generally")
							.padding(.top, 70)
					}
					.listRowBackground(Color("cardView"))

					Section{
						Button("Prayer times") {
							showCalculation.toggle()
						}
						.foregroundColor(Color("cardView.title"))
						.sheet(isPresented: $showCalculation) {
							CalculationSettingsView()
						}
					} header: {
						Text("Calculationmethod")
					}
					.listRowBackground(Color("cardView"))

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
					.listRowBackground(Color("cardView"))
					
					Section {
						Button("Review the app") {
							requestReview()
						}
						.foregroundColor(Color("cardView.title"))
						Button("Restore purchase") {
						}
						.foregroundColor(Color("cardView.title"))
					}.listRowBackground(Color("cardView"))
				}
				.frame(height: 600)
				.scrollContentBackground(.hidden)
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
				PatternBG(pattern: false)
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
			PatternBG(pattern: false)
			ScrollView {
				VStack {
					Capsule().fill(Color.secondary).frame(width: 35, height: 5).padding(.top)
					FormSection(header: "Calculation for different regions", footer: "An approximation of the Diyanet method used in Turkey. This approximation is less accurate outside the region of Turkey.") {
						ZStack(alignment: .center) {
							RoundedRectangle(cornerRadius: 13, style: .continuous)
								.fill(Color("cardView"))
								.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
								.padding(5)
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
							.padding(.horizontal, 22)
							.padding(.vertical, 12)
						}
						.padding(.horizontal)
					}

					FormSection(header: "Madhab", footer: "Rule for calculating the time for Asr.\n**Shafi:** Earlier Asr time (Shafi, Maliki, Hanbali, Jafari)\n**Hanafi:** Later Asr time.") {
						ZStack(alignment: .center) {
							RoundedRectangle(cornerRadius: 13, style: .continuous)
								.fill(Color("cardView"))
								.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
								.padding(5)
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
							.padding(.horizontal, 22)
							.padding(.vertical, 12)
						}
						.padding(.horizontal)
					}

					FormSection(header: "Time correction", footer: "") {
						ZStack(alignment: .center) {
							RoundedRectangle(cornerRadius: 13, style: .continuous)
								.fill(Color("cardView"))
								.frame(maxWidth: .infinity, alignment: .leading)
								.padding(5)
							VStack {
								TimeShiftView(count: $fajr, 	name: "ttFajr")
								TimeShiftView(count: $sunrise, 	name: "ttSunrise")
								TimeShiftView(count: $dhur, 	name: "ttDhur")
								TimeShiftView(count: $asr, 		name: "ttAsr")
								TimeShiftView(count: $maghrib,	name: "ttMaghrib")
								TimeShiftView(count: $isha, 	name: "ttIsha")
							}.padding(.vertical)
						}
						.padding(.horizontal)
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
			}.padding(.horizontal, 22)
		}
	}
}

#Preview {
	SettingsView()
}
