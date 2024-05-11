import Foundation
import SwiftUI

struct Background : View {

	@Environment(\.colorScheme) var colorScheme
	let pattern: Bool

	var body: some View {
		LinearGradient(gradient: Gradient(colors: [getBackgroundGradientA(), getBackgroundGradientA()]), startPoint: .top, endPoint: .bottom)
			.ignoresSafeArea()
		if(pattern){
			Image("pattern")
				.resizable()
				.scaledToFit()
				.mask(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.15),  .black.opacity(0.1), .black.opacity(0)]), startPoint: .top, endPoint: .bottom))
				.foregroundColor(Color("patternColor").opacity(0.5))
				.opacity(0.4)
				.ignoresSafeArea()
		}
	}
	// #8D9DAA #D6C8BC
	// #7F809A #D6C8BC
	// #838FA3 #BBB39F
	// #838FA3 #9CA086
	// #838FA3 #9F9287
	// #838FA3 #C4A68A
	// #7F809A #C4A68A
	// #7F809A #7E7267
	// #8D9DAA #AA9A8D
	// #7F809A #9A997F
	// #474f55" #56504b
	// #bbc4cc" #ddd7d1
	func getBackgroundGradientA() -> Color {
		switch colorScheme {
		case .light:
			return Color(hex: "#ccced0")
		case .dark:
			return Color(hex: "#08090a")
		default:
			return .red
		}
	}

	func getBackgroundGradientB() -> Color {
		switch colorScheme {
		case .light:
			return Color(hex: "#D6C8BC")
		case .dark:
			return Color(hex: "#56504B")
		default:
			return .red
		}
	}
}

struct CardViewDouble<Content: View> : View {
	
	var content: () -> Content
	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content
	}
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(.ultraThinMaterial)
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.fill(.regularMaterial)
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
				.padding(5)
			content()
				.padding(22)
		}
		.padding(.horizontal)
		.padding(.bottom, 8)
	}
}

struct CardView2<Content: View, Content2: View> : View {

	var content: () -> Content
	var content2: () -> Content2
	init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder content2: @escaping () -> Content2) {
		self.content = content
		self.content2 = content2
	}
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(.ultraThinMaterial)
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.fill(.regularMaterial)
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
				.padding(5)
			content()
				.padding(22)
		}
		.padding(.horizontal)
		.padding(.bottom, 8)
	}
}

struct CardView3<Content: View, Content2: View> : View {

	var content: () -> Content
	var content2: () -> Content2
	init(@ViewBuilder content: @escaping () -> Content, @ViewBuilder content2: @escaping () -> Content2) {
		self.content = content
		self.content2 = content2
	}
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(.ultraThinMaterial)
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.fill(.regularMaterial)
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
				.padding(5)
			content()
				.padding(22)
		}
		.padding(.horizontal)
		.padding(.bottom, 8)
	}
}

struct CardView<Content: View>: View {
	let option: Bool
	var content: Content

	init(option: Bool, @ViewBuilder content: () -> Content) {
		self.content = content()
		self.option = option
	}
	
	var body: some View {
		_VariadicView.Tree(DividedVStackLayout(option: option)) {
			content
		}
	}
}

struct DividedVStackLayout: _VariadicView_UnaryViewRoot {

	let option: Bool

	@ViewBuilder
	func body(children: _VariadicView.Children) -> some View {
		let last = children.last?.id

		ZStack(alignment: .topLeading) {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(.ultraThinMaterial)
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
			VStack {
				ForEach(children) { child in
					ZStack(alignment: .topLeading) {
						if !(option && child.id == last){
							RoundedRectangle(cornerRadius: 16, style: .continuous)
								.fill(.regularMaterial)
								.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						}
						child
							.padding(22)
					}
				}
			}
			.padding(5)
		}
		.padding(.horizontal)
		.padding(.bottom, 8)
	}
}

struct SubmitButton: View {
	
	var title: String
	var icon: String
	var action: () -> Void

	var body: some View {
		VStack{
			Spacer()
			Button(action: { action() }, label: {
				ZStack(alignment: .center) {
					RoundedRectangle(cornerRadius: 16, style: .continuous)
						.fill(.regularMaterial)
						.shadow(color: .black.opacity(0.15), radius: 24, x: 0, y: 8)
						.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
						.padding(5)
					HStack {
						Text(title)
							.font(.headline)
							.fontWeight(.bold)
							.foregroundColor(Color("cardView.title"))
						Spacer()
						Image(icon)
							.resizable()
							.imageScale(.small)
							.frame(width: 30, height: 30)
							.foregroundColor(Color("cardView.title"))
					}.padding(.horizontal, 22)
				}
			})
			.foregroundColor(Color("cardView.title"))
			.padding(.horizontal)
			.padding(.bottom, 6)
		}
	}
	
}

// Simple preference that observes a CGFloat.
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
	static var defaultValue = CGFloat.zero
	
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value += nextValue()
	}
}

struct OScrollView<Content>: View where Content : View {

	@Namespace var scrollSpace
	@Binding var offset: CGFloat
	let content: (ScrollViewProxy) -> Content
	
	init(offset: Binding<CGFloat>, @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
		_offset = offset
		self.content = content
	}
	
	var body: some View {
		ScrollView(showsIndicators: false){
			ScrollViewReader { proxy in
				content(proxy)
					.background(GeometryReader { proxy in
						let offset = -proxy.frame(in: .named(scrollSpace)).minY
						Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
					})
			}
		}
		.coordinateSpace(name: scrollSpace)
		.onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
			offset = value
		}
	}
}

func vibrate(style: UIImpactFeedbackGenerator.FeedbackStyle, pref: Bool){
	if(pref){
		UIImpactFeedbackGenerator(style: style).impactOccurred()
	}
}
