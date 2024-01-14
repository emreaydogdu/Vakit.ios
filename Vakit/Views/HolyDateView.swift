import SwiftUI

struct HolyDateView: View {
	
	@State var capitals: [HolyDate] = []
	@State private var show = false
	@State private var defaultv: CGPoint = .zero
	
	var body: some View {
		ZStack(alignment: .top){
			PatternBG(pattern: false)
			ScrollView(showsIndicators: false) {
				ForEach(capitals, id: \.id) { country in
					ZStack(alignment: .leading){
						Text(Date().getHolyGregorianStr(dateStr: country.gregorian))
							.font(.callout)
							.fontWeight(.semibold)
							.multilineTextAlignment(.center)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.leading)
						Circle()
							.fill(.black)
							.frame(width: 20, alignment: .leading)
							.padding(.leading, 85)
						Circle()
							.fill(.white)
							.frame(width: 10, alignment: .leading)
							.padding(.leading, 90)
						Divider()
							.frame(minHeight: 2)
							.overlay(.black)
							.padding(.leading, 100)
						RoundedRectangle(cornerRadius: 15, style: .continuous)
							.fill(Color("cardView"))
							.padding(.horizontal)
							.padding(.leading, 100)
						VStack(spacing: 10){
							Text(LocalizedStringKey(country.name))
								.font(.headline)
								.fontWeight(.semibold)
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(LocalizedStringKey(country.desc))
								.font(.subheadline)
								.frame(maxWidth: .infinity, alignment: .leading)
							Text(Date().getHolyHijri(dateStr: country.gregorian))
								.font(.subheadline)
								.fontWeight(.semibold)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
						.padding()
						.padding(.leading, 120)
					}
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
			.contentMargins(.top, 80, for: .scrollContent)
			.onAppear {
				capitals = csvStringToArray(stringCSV: "HolyDates.csv")
			}
			Toolbar(show: $show)
		}
		.navigationBarBackButtonHidden(true)
	}
	
	func csvStringToArray(stringCSV: String) -> [HolyDate] {
		var dataArray: [HolyDate] = []
		if let filepath = Bundle.main.path(forResource: stringCSV, ofType: nil) {
			do {
				let csvRows = try String(contentsOfFile: filepath)
				let lines = csvRows.components(separatedBy: "\n")
				for i in lines {
					let columns = i.components(separatedBy: ",")
					let csvColumns: HolyDate = HolyDate.init(name: columns[0].trimmingCharacters(in: .whitespacesAndNewlines), desc: columns[1].trimmingCharacters(in: .whitespacesAndNewlines), gregorian: Date().getHolyGregorian(dateStr: columns[2])!, mode: Int(columns[3].trimmingCharacters(in: .whitespacesAndNewlines))!)
					dataArray.append(csvColumns)
				}
				return dataArray
			} catch { print("error: \(error)") }
		}
		return dataArray
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
			Text("Holy Days")
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

#Preview {
	HolyDateView()
}
