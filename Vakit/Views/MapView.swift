import SwiftUI
import MapKit

struct MapView: View {
	
	@State private var show = false
	@State private var mosques = [Mosque.Result]()
	@State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
	@State private var selectedMosque: Mosque.Result?
	@State private var sheetContentHeight = CGFloat(0)
	@State private var isPresentingConfirm = false
	@State private var splash = true
	
	var body: some View {
		ZStack(alignment: .top){
			Map(position: $position) {
				ForEach(mosques, id: \.place_id) { location in
					Annotation(location.name, coordinate: CLLocationCoordinate2D(latitude: location.geometry.location.lat, longitude: location.geometry.location.lng), anchor: .bottom) {
						ZStack {
							Circle()
								.foregroundStyle(Color.gray.opacity(0.6))
								.frame(width: 40, height: 40)
							
							Image(systemName: "moon.stars.fill")
								.symbolEffect(.variableColor)
								.padding()
								.foregroundStyle(Color("color"))
								.background(Color.gray.opacity(0.2))
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
						.actionSheet(isPresented: $isPresentingConfirm) {
							ActionSheet(
								title: Text("Choose your Application"),
								buttons: [
									.cancel(),
									.default(Text("Apple Maps"), action: {
										openMaps(lat: mosque.geometry.location.lat, lng: mosque.geometry.location.lng, maps: 0)
									}),
									.default(Text("Google Maps"), action: {
										openMaps(lat: mosque.geometry.location.lat, lng: mosque.geometry.location.lng, maps: 1)
									})
								]
							)
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
			.task{
				//mosques = await Mosques().getMosques()
			}
			.onChange(of: mosques.count, perform: { value in
				print(mosques.count)
			})
			
			if(splash){
				GeometryReader{ proxy in
					ZStack(alignment: .top){
						Color("backgroundColor")
						VStack {
							Image("splash_mosque")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.padding(.top, 150)
								.padding(.horizontal)
							Text("Find the nearest mosques in your area")
								.font(.title)
								.fontWeight(.bold)
							Text("Please provide location service access")
								.font(.title2)
						}
						.padding(.horizontal)
						SubmitButton(title: "Start searching", icon: "ic_share"){
							splash.toggle()
							Task{
								mosques = await Mosques().getMosques()
								print(mosques)
							}
						}
						.padding(.bottom, 100)
					}
				}.ignoresSafeArea()
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
