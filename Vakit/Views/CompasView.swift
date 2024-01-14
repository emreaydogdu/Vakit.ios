import SwiftUI
import CoreLocation
import CoreHaptics
import Adhan

enum Mode {
	case ahead, right
}

struct CompasView: View {
	@State var mode = Mode.right
	var locationManager = CLLocationManager()
	@ObservedObject var location: LocationProvider = LocationProvider()
	@State var angle: CGFloat = 0
	let qiblaDirection = Qibla(coordinates: Coordinates(latitude: 52.463743, longitude: 13.395164)).direction
	
	@State private var opacity: Double = 0.0
	@State private var scale: Double = 1.0
	@State private var offset: Double = -8.0
	@State private var show = false
	
	var body: some View {
		ZStack(alignment: .top){
			PatternBG(pattern: false)
			GeometryReader { geometry in
				ZStack {
					ZStack {
						ZStack {
							VStack {
								Circle()
									.fill(Color(mode == .ahead ? UIColor.label : UIColor.secondaryLabel))
									.frame(width: 16, height: 16)
									.offset(y: offset)
									.scaleEffect(scale)
								Spacer()
							}
							
							Circle()
								.trim(from: 0.025, to: mod(self.angle, 360) < 180 ? (self.angle.remainder(dividingBy: 360) / 360) - 0.025 : 0)
								.rotation(Angle(degrees: -90))
								.stroke(Color(UIColor.label), style: StrokeStyle(lineWidth: 16, lineCap: .round))
								.opacity(opacity)
							
							Circle()
								.trim(from: mod(self.angle, 360) >= 180 ? (1 - abs(self.angle.remainder(dividingBy: 360)) / 360) + 0.025 : 1, to: 0.975)
								.rotation(Angle(degrees: -90))
								.stroke(Color(UIColor.label), style: StrokeStyle(lineWidth: 16, lineCap: .round))
								.opacity(opacity)
						}
						.frame(width: 312, height: 312)
						
						ZStack {
							HStack {
								Spacer()
								Circle()
									.frame(width: 16, height: 16)
									.offset(x: 8)
									.opacity(opacity)
							}
						}
						.frame(width: 312, height: 312)
						.rotationEffect(Angle(degrees: self.angle - 90))
						
						Image(systemName: "arrow.up")
							.font(.system(size: 192, weight: .bold))
							.rotationEffect(Angle(degrees: self.angle))
					}
					.offset(y: -60)
					
					VStack {
						
						Spacer()
						VStack {
							HStack {
								//Text("\(abs(round(Double(mod(self.angle, 180)))))")
								Text("\(mod(self.angle, 360) < 180 ? mod(self.angle, 360) : abs(mod(self.angle, 360) - 360))")
								Text("°")
									.foregroundColor(Color(UIColor.secondaryLabel))
								Spacer()
							}
							
							HStack {
								if mode == .right {
									Text("to your")
									Text(mod(self.angle, 360) < 180 ? "left" : "right")
										.foregroundColor(Color(UIColor.secondaryLabel))
								} else {
									Text("ahead")
								}
								
								Spacer()
							}
						}
						.font(.system(size: 48, design: .rounded))
						.padding(.bottom)
						/*
						 HStack  {
						 Button(action: { }) {
						 Image(systemName: "xmark")
						 .font(.system(size: 24, weight: .semibold))
						 .padding(20)
						 .background(
						 Circle()
						 .fill(Color(UIColor.tertiaryLabel))
						 )
						 }
						 .buttonStyle(PlainButtonStyle())
						 
						 Spacer()
						 
						 Button(action: { }) {
						 Image(systemName: "speaker.slash.fill")
						 .font(.system(size: 24, weight: .semibold))
						 .padding(20)
						 .background(
						 Circle()
						 .fill(Color(UIColor.tertiaryLabel))
						 )
						 }
						 .buttonStyle(PlainButtonStyle())
						 }
						 .hidden()
						 .padding(.horizontal)
						 */
					}
					.padding()
				}
				.background((mode == .ahead ? Color.green : Color.clear).edgesIgnoringSafeArea(.all))
				.onReceive(self.location.heading) { heading in
					let diff = (heading - self.angle + 180).truncatingRemainder(dividingBy: 360) - 180 - round(qiblaDirection)
					if diff < -300 {
						//diff += 360
					}
					withAnimation {
						self.angle += diff
					}
					withAnimation(.easeInOut(duration: 0.4)) {
						opacity = mode == .ahead ? 0.0 : 1.0
						scale = mode == .ahead ? 2.0 : 1.0
						offset = mode == .ahead ? -4.0 : -8.0
					}
					if (mod(self.angle, 360) <= 10 || mod(self.angle, 360) >= 350){
						toggleMode(opt: true)
						if ((mod(self.angle, 2)) == 0) {
							UIImpactFeedbackGenerator(style: .medium).impactOccurred()
						}
					} else {
						if ((mod(self.angle, 2)) == 0) {
							UIImpactFeedbackGenerator(style: .soft).impactOccurred()
						}
						toggleMode(opt: false)
					}
				}
				.onAppear{ self.location.updateHeading() }
				.onDisappear{ self.location.disableHeading() }
			}
			.background(.clear)
			ToolbarStd(title: "Compas", show: $show)
		}
	}
	
	func mod(_ a: CGFloat, _ n: Int) -> Int {
		precondition(n > 0, "modulus must be positive")
		let r = Int(a) % n
		return r >= 0 ? r : r + n
	}
	
	func toggleMode(opt: Bool) {
		if opt == false {
			withAnimation(.easeInOut(duration: 1)) {
				mode = .right
			}
		} else {
			withAnimation(.easeInOut(duration: 1)) {
				mode = .ahead
			}
		}
	}
}

#Preview {
	CompasView()
}
