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
