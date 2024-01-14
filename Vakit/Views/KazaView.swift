import SwiftUI

struct KazaView: View {
	
	@State private var show = false
	@State private var defaultv: CGPoint = .zero
	@AppStorage("kaza_fajr")	private var fajr 	= 0
	@AppStorage("kaza_sunrise")	private var sunrise = 0
	@AppStorage("kaza_dhur")	private var dhur 	= 0
	@AppStorage("kaza_asr")		private var asr 	= 0
	@AppStorage("kaza_maghrib")	private var maghrib = 0
	@AppStorage("kaza_isha")	private var isha 	= 0
	
	var body: some View {
		ZStack(alignment: .top) {
			PatternBG(pattern: false)
			ScrollView {
				Form {
					Section(header: Text(""), footer: Text("KazaViewFooter")) {
						KazaCountView(count: $fajr, 	name: "ttFajr")
						KazaCountView(count: $sunrise, 	name: "ttSunrise")
						KazaCountView(count: $dhur, 	name: "ttDhur")
						KazaCountView(count: $asr, 		name: "ttAsr")
						KazaCountView(count: $maghrib,	name: "ttMaghrib")
						KazaCountView(count: $isha, 	name: "ttIsha")
					}
					.listRowBackground(Color("cardView"))
				}
				.frame(height: 550)
				.contentMargins(.top, 40, for: .scrollContent)
				.scrollContentBackground(.hidden)
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
			ToolbarBck(title: "Missed Prayers", show: $show)
		}
		.navigationBarBackButtonHidden(true)
	}
}

struct KazaCountView : View {
	
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

#Preview {
	KazaView()
}
