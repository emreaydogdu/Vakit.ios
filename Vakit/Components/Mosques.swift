import SwiftUI

struct Mosque: Codable {
	var status: String
	var results: [Result]
	
	struct Result: Codable, Identifiable {
		let id = UUID()
		var place_id: String
		var name: String
		var vicinity: String
		var rating: Double
		var user_ratings_total: Int
		var geometry: Geometry
		
		struct Geometry: Codable {
			var location: Location
			
			struct Location: Codable {
				var lat: Double
				var lng: Double
			}
		}
	}
}

class Mosques: ObservableObject {
	
	@Published var results = [Mosque.Result]()
	
	@MainActor
	func loadMosques() async {
		@State var locationDataManager = LocationManager()
		
		guard let url2 = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(locationDataManager.getLat()),\(locationDataManager.getLng())&radius=15000&type=mosque&key=AIzaSyBypg2GZCS-SwdWfj-C29O5whnnh7UydyA") else {
			print("Invalid URL")
			return
		}
		do {
			let (data, _) = try await URLSession.shared.data(from: url2)
			
			if let decodedResponse = try? JSONDecoder().decode(Mosque.self, from: data) {
				results = decodedResponse.results
			}
		} catch {
			print("Invalid data")
		}
	}
	
	func getMosques() async -> [Mosque.Result] {
		await loadMosques()
		return results
	}
}

