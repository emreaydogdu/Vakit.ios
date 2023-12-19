import SwiftUI
import CoreLocation

struct Places: View {
	
	@StateObject var locationDataManager = LocationManager()
	@State private var status : String = "test"
	@State private var results = [Response.Result]()
	
	var body: some View {
		VStack {
			Text("\(status)")
			Text(locationDataManager.getLat())
			List(results, id: \.place_id) { item in
				VStack(alignment: .leading) {
					Text(item.name)
						.font(.headline)
					Text(item.geometry.location.lat.formatted(.number.precision(.fractionLength(2...))))
						.font(.headline)
					Text(item.geometry.location.lng.formatted(.number.precision(.fractionLength(2...))))
						.font(.headline)
				}
			}
			.task {
				await loadData()
			}
		}
	}
	
	func loadData() async {
		guard let url2 = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationDataManager.getLat()),\(locationDataManager.getLng())&radius=15000&type=mosque&key=AIzaSyBypg2GZCS-SwdWfj-C29O5whnnh7UydyA") else {
			print("Invalid URL")
			return
		}
		do {
			let (data, _) = try await URLSession.shared.data(from: url2)
			
			if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
				status = decodedResponse.status
				results = decodedResponse.results
			}
		} catch {
			print("Invalid data")
		}
	}
}

#Preview {
	Places()
}
