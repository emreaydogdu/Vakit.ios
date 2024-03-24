import Foundation
import SwiftUI

struct ToolbarStd : View {
	
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	var title: String
	@Binding var show: Bool
	
	var body: some View {
		Text(LocalizedStringKey(title))
			.font(.title2)
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
