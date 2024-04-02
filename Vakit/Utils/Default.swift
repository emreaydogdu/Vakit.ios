import Foundation
import SwiftUI

struct PatternBG : View {
	
	let pattern: Bool
	var body: some View {
		Color("backgroundColor")
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

#Preview{
	PatternBG(pattern: true)
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

#Preview{
	PatternBG(pattern: true)
}
