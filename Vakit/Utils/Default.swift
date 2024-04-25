import Foundation
import SwiftUI

struct PatternBG : View {
	
	let pattern: Bool
	var body: some View {
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
		LinearGradient(gradient: Gradient(colors: [Color(hex: "#797982"), Color(hex: "#D6C8BC")]), startPoint: .top, endPoint: .bottom)
			.ignoresSafeArea()
		if(pattern){
			Image("pattern")
				.resizable()
				.scaledToFit()
				.mask(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.15),  .black.opacity(0.1), .black.opacity(0)]), startPoint: .top, endPoint: .bottom))
				.opacity(0.9)
				.foregroundColor(Color("patternColor").opacity(0.4))
				.ignoresSafeArea()
		}
	}
}

struct BlurBG : UIViewRepresentable {

	func makeUIView(context: Context) -> UIVisualEffectView {
		let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
		return view
	}

	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct CardViewDouble<Content: View> : View {
	
	var content: () -> Content
	init(@ViewBuilder content: @escaping () -> Content) {
		self.content = content
	}
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(Color("cardView.sub"))
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
			RoundedRectangle(cornerRadius: 16, style: .continuous)
				.fill(Color("cardView"))
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
				.padding(5)
			content()
				.padding(22)
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
						.fill(Color(hex: "#C1D2E7"))
						.shadow(color: .black.opacity(0.15), radius: 24, x: 0, y: 8)
						.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
						.padding(5)
					HStack {
						Text(title)
							.font(.headline)
							.fontWeight(.bold)
							.foregroundColor(Color(hex: "#141414"))
						Spacer()
						Image(icon)
							.resizable()
							.imageScale(.small)
							.frame(width: 30, height: 30)
							.foregroundColor(Color(hex: "#141414"))
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
	@Binding var scrollOffset: CGFloat
	let content: (ScrollViewProxy) -> Content
	
	init(scrollOffset: Binding<CGFloat>, @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
		_scrollOffset = scrollOffset
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
			scrollOffset = value
		}
	}
}

func vibrate(style: UIImpactFeedbackGenerator.FeedbackStyle, pref: Bool){
	if(pref){
		UIImpactFeedbackGenerator(style: style).impactOccurred()
	}
}
