import SwiftUI
import CoreLocation

struct CompasTest: View {
	
	var locationManager = CLLocationManager()
	@ObservedObject var location: LocationProvider = LocationProvider()
	@State var angle: CGFloat = 0
	
	var body: some View {
		
		NavigationView{
			ZStack{
				Color("bg").ignoresSafeArea()
				GeometryReader { geometry in
					Image("CompassArrow")
						.foregroundColor(.white)
						.onReceive(self.location.heading) { heading in
							var diff = (heading - self.angle + 180).truncatingRemainder(dividingBy: 360) - 180
							if diff < -300 {
								diff += 360
							}
							withAnimation {
								self.angle += diff
							}
						}
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.rotationEffect(Angle(degrees: -self.angle))
						//.modifier(RotationEffect(angle: self.angle))
				}
			}
			.navigationTitle("Qibla Direction")
		}
	}
}

struct RotationEffect: GeometryEffect {
	var angle: CGFloat
	
	var animatableData: CGFloat {
		get { angle }
		set { angle = newValue }
	}
	
	func effectValue(size: CGSize) -> ProjectionTransform {
		return ProjectionTransform(
			CGAffineTransform(translationX: -150, y: -150)
				.concatenating(CGAffineTransform(rotationAngle: -CGFloat(angle.degreesToRadians)))
				.concatenating(CGAffineTransform(translationX: 150, y: 150))
		)
	}
}

public extension CGFloat {
	var degreesToRadians: CGFloat { return self * .pi / 180 }
	var radiansToDegrees: CGFloat { return self * 180 / .pi }
}

public extension Double {
	var degreesToRadians: Double { return Double(CGFloat(self).degreesToRadians) }
	var radiansToDegrees: Double { return Double(CGFloat(self).radiansToDegrees) }
	
	var stringWithoutZeroFraction: String {
		return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
	}
}

struct CompasTest_Previews: PreviewProvider {
	static var previews: some View {
		CompasTest()
	}
}
