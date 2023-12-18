import SwiftUI

struct TestView: View {
	
	@StateObject var locationDataManager = LocationManager()

	var body: some View {
		VStack {
			Text("Latitude: \(locationDataManager.getLat())")
			Text("Latitude: \(locationDataManager.getLng())")
		}
	}
}

#Preview {
	TestView()
}
