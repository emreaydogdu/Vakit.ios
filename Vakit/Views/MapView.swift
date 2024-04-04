import SwiftUI
import MapKit

struct MapView: View {
	
	@State private var show = true
	@State private var mosques = [Mosque.Result]()
	@State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
	@State private var selectedMosque: Mosque.Result?
	@State private var sheetContentHeight = CGFloat(0)
	@State private var isPresentingConfirm = false
	
	var body: some View {
		ZStack(alignment: .top){
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
						.onTapGesture {
							selectedMosque = location
						}
					}
				}
				UserAnnotation()
			}
			.sheet(item: $selectedMosque) { mosque in
						 ZStack {
							 PatternBG(pattern: false)
							 VStack {
								 ZStack {
									 RoundedRectangle(cornerRadius: 20, style: .continuous)
										 .fill(Color("cardView.sub"))
										 .shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
									 RoundedRectangle(cornerRadius: 16, style: .continuous)
										 .fill(Color("cardView"))
										 .shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
										 .padding(5)
									 VStack{
										 ShareLink(item: "") {
											 HStack {
												 Text(mosque.name)
													 .font(.headline)
													 .fontWeight(.bold)
													 .foregroundColor(Color("textColor"))
													 .frame(maxWidth: .infinity, alignment: .leading)
												 Image("ic_share")
													 .resizable()
													 .imageScale(.small)
													 .frame(width: 28, height: 28)
													 .foregroundColor(Color("cardView.title"))
											 }
										 }
										 Text(mosque.vicinity)
											 .font(.body)
											 .foregroundColor(Color("subTextColor"))
											 .frame(maxWidth: .infinity, alignment: .leading)
											 .padding(.top, 8)
											 .padding(.bottom)
											 .transition(.opacity)
										 HStack{
											 Spacer()
											 RatingView(maxRating: 5, rating: mosque.rating, starColor: Color("color"))
											 Text("(\(mosque.user_ratings_total))")
												 .font(.body)
												 .foregroundColor(Color("textColor"))
												 .transition(.opacity)
												 .environment(\.layoutDirection, .rightToLeft)
										 }
										 Text("chapter")
											 .font(.headline)
											 .foregroundColor(Color("textColor"))
											 .fontWeight(.bold)
											 .frame(maxWidth: .infinity, alignment: .leading)
									 }
									 .padding(22)
								 }
								 .padding()
								 Spacer()
								 SubmitButton(title: "Navigate", icon: "ic_share") {
									 switch checkMaps() {
										 case 0:
											 isPresentingConfirm.toggle()
										 case 1:
											 openMaps(lat: mosque.geometry.location.lat, lng: mosque.geometry.location.lng, maps: 0)
										 case 2:
											 openMaps(lat: mosque.geometry.location.lat, lng: mosque.geometry.location.lng, maps: 1)
										 default:
											 print("Failed")
									 }
								 }
								 .confirmationDialog("Choose your Application",  isPresented: $isPresentingConfirm, titleVisibility: .visible) {
									 Button("Apple Maps") {
										 openMaps(lat: mosque.geometry.location.lat, lng: mosque.geometry.location.lng, maps: 0)
									 }
									 Button("Google Maps") {
										 openMaps(lat: mosque.geometry.location.lat, lng: mosque.geometry.location.lng, maps: 1)
									 }
								 }
							 }
							 .padding(.vertical)
						 }
						 .background {
							 GeometryReader { proxy in
								 Color.clear.task { sheetContentHeight = proxy.size.height + 50 }
							 }
						 }.presentationDetents([.height(sheetContentHeight)])
					 }
			.mapControls(){
				MapUserLocationButton().padding(.top, 100)
				MapPitchToggle()
				MapCompass()
				MapScaleView()
			}
			.contentMargins(.top, 60, for: .automatic)
			.mapStyle(.standard(pointsOfInterest: []))
			.task {
				mosques = await Mosques().getMosques()
			}
			ToolbarStd(title: "Nearby Mosques", show: $show)
		}
	}

	func openMaps(lat: Double, lng: Double, maps: Int){
		let appleUrl  = URL(string: "maps://?saddr=&daddr=\(lat),\(lng)")!
		let googleUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lng)")!
		if UIApplication.shared.canOpenURL((maps == 0) ? appleUrl : googleUrl) {
			UIApplication.shared.open((maps == 0) ? appleUrl : googleUrl, options: [:], completionHandler: nil)
		}
	}

	func checkMaps() -> Int {
		let appleUrl  = URL(string: "maps://")!
		let googleUrl = URL(string: "comgooglemaps://")!
		if (UIApplication.shared.canOpenURL(appleUrl) && UIApplication.shared.canOpenURL(googleUrl)) {
			return 0
		} else if (UIApplication.shared.canOpenURL(appleUrl)) {
			return 1
		} else if (UIApplication.shared.canOpenURL(googleUrl)) {
			return 2
		}
		return -1
	}

}

#Preview {
	MapView()
}
