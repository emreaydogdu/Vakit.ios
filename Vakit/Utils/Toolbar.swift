import Foundation
import SwiftUI

private struct BlurBG : UIViewRepresentable {

	func makeUIView(context: Context) -> UIVisualEffectView {
		let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
		return view
	}

	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct Toolbar : View {
	
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	var title: String
	@Binding var show: Bool
	
	var body: some View {
		Text(LocalizedStringKey(title))
			.font(.title)
			.fontWeight(.bold)
			.frame(maxWidth: .infinity, alignment: .center)
			.padding(.leading, 5.0)
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

struct ToolbarBck : View {
	
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	var title: String
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
			Text(LocalizedStringKey(title))
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

struct ToolbarHome : View {

	@Binding var show: Bool
	var body: some View {
		HStack {
			VStack(alignment: .leading, spacing: 5) {
				Text(Date().getNavDate())
					.font(.custom("Montserrat-Bold", size: 20.0))
				Text(Date().getHijriDate())
					.font(.custom("Montserrat-Medium", size: 18.0))
			}
			Spacer(minLength: 0)
			Button(action: {}) {
				Text("Try")
					.foregroundColor(.white)
					.padding(.vertical,10)
					.padding(.horizontal, 25)
					.background(Color("color"))
					.clipShape(Capsule())
			}
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
