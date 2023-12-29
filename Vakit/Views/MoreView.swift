import SwiftUI

struct Card {
	let prompt: String
	let answer: String
	
	static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}

extension Color {
	init(hex: String) {
		var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
		var rgb: UInt64 = 0
		
		Scanner(string: cleanHexCode).scanHexInt64(&rgb)
		
		let redValue = Double((rgb >> 16) & 0xFF) / 255.0
		let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
		let blueValue = Double(rgb & 0xFF) / 255.0
		self.init(red: redValue, green: greenValue, blue: blueValue)
	}
}

extension UINavigationController: UIGestureRecognizerDelegate {
	override open func viewDidLoad() {
		super.viewDidLoad()
		interactivePopGestureRecognizer?.delegate = self
	}
	
	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return viewControllers.count > 1
	}
}

struct MoreView: View {
	let card: Card
	@State private var hideTabBar = true
	
	var body: some View {
		NavigationView {
			ZStack(alignment: .top){
				Color("backgroundColor").ignoresSafeArea()
				Image("pattern")
					.frame(minWidth: 0, maxWidth: .infinity)
					.mask(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.15),  .black.opacity(0.1), .black.opacity(0)]), startPoint: .top, endPoint: .bottom))
					.opacity(0.6)
					.foregroundColor(Color("patternColor").opacity(0.4))
					.ignoresSafeArea()
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
											.padding(19)
											.frame(width: 70, height: 70)
									}.frame(width: 70, height: 70)
								}
							}
							Divider().frame(height: 2).overlay(Color("cardView.sub"))
							HStack{
								VStack{
									Text("Live interaction")
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
								RoundedRectangle(cornerRadius: 15, style: .continuous)
									.fill(Color(hex: "#B0DDF0"))
									.frame(width: 70, height: 70)
							}
							Divider().frame(height: 2).overlay(Color("cardView.sub"))
							HStack{
								VStack{
									Text("Realtime collaburation")
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
								RoundedRectangle(cornerRadius: 15, style: .continuous)
									.fill(Color(hex: "#C6E7B8"))
									.frame(width: 70, height: 70)
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
									RoundedRectangle(cornerRadius: 10, style: .continuous)
										.fill(Color("cardView.sub"))
										.frame(width: 40, height: 40)
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
								RoundedRectangle(cornerRadius: 10, style: .continuous)
									.fill(Color("cardView.sub"))
									.frame(width: 40, height: 40)
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
	MoreView(card: Card.example)
}
