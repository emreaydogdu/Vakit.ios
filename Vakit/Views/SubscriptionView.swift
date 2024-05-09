import SwiftUI
import StoreKit

struct SubscriptionView: View {

	var body: some View {
		VStack {
			ProductView(id: "sub.month") { _ in
				Image(systemName: "crown")
					.resizable()
					.scaledToFit()
			} placeholderIcon: {
				ProgressView()
			}
			.productViewStyle(.compact)
		}
	}
}

#Preview {
	SubscriptionView()
}
