import SwiftUI
import MapKit

struct MapView: View {
	
	@State private var mosques = [Mosque.Result]()
	@State private var position: MapCameraPosition = .userLocation(fallback: .automatic)

	var body: some View {
		Map(position: $position) {
			ForEach(mosques, id: \.place_id) { location in
				Annotation(location.name, coordinate: CLLocationCoordinate2D(latitude: location.geometry.location.lat, longitude: location.geometry.location.lng), anchor: .bottom) {
					ZStack {
						Circle()
							.foregroundStyle(Color.accentColor.opacity(0.5))
							.frame(width: 70, height: 70)
						
						Image(systemName: "moon.stars.fill")
							.symbolEffect(.variableColor)
							.padding()
							.foregroundStyle(.white)
							.background(Color.accentColor)
							.clipShape(Circle())
					}
				}
			}
			UserAnnotation()
		}
		.mapControls(){
			MapUserLocationButton().padding(.top)
			MapPitchToggle()
			MapCompass()
		}
		.mapStyle(.standard(pointsOfInterest: []))
		.task {
			mosques = await Mosques().getMosques()
		}
	}

}

#Preview {
	MapView()
}
