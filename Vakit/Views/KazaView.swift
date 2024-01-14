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
			Toolbar(show: $show)
		}
		.navigationBarBackButtonHidden(true)
	}
}

private struct Toolbar : View {
	
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Binding var show: Bool
	
	var body: some View {
		ZStack(alignment: .leading){
			Button(action: {self.presentationMode.wrappedValue.dismiss()}) {
				Image(systemName: "chevron.left")
					.foregroundColor(Color("cardView.title"))
					.padding(5)
			}
			.buttonStyle(.bordered)
			.clipShape(Circle())
			Text("Missed prayers")
				.font(.title2)
				.fontWeight(.bold)
				.frame(maxWidth: .infinity, alignment: .center)
				.padding(.leading, 5.0)
		}
		.padding(.top, UIApplication.safeAreaInsets.top == 0 ? 15 : UIApplication.safeAreaInsets.top + 5)
		.padding(.horizontal)
		.padding(.bottom)
		.background(show ? BlurBG() : nil)
		.onChange(of: show, { oldValue, newValue in
			UIImpactFeedbackGenerator(style: .soft).impactOccurred()
		})
		.ignoresSafeArea()
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
