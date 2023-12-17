import SwiftUI
import CoreLocation

enum Mode {
	case ahead, right
}

struct Finding: View {
	@State var mode = Mode.right
	var locationManager = CLLocationManager()
	@ObservedObject var location: LocationProvider = LocationProvider()
	@State var angle: CGFloat = 290
	
	var body: some View {
		NavigationView {
			GeometryReader { geometry in
				ZStack {
					ZStack {
						ZStack {
							VStack {
								Circle()
									.fill(Color(mode == .ahead ? UIColor.label : UIColor.secondaryLabel))
									.frame(width: 16, height: 16)
									.offset(y: mode == .ahead ? -4 : -8)
									.scaleEffect(mode == .ahead ? 2 : 1)
								Spacer()
							}
							
							Circle()
								.trim(from: 0.025, to: mod(self.angle, 360) < 180 ? (self.angle.remainder(dividingBy: 360) / 360) - 0.025 : 0)
								.rotation(Angle(degrees: -90))
								.stroke(Color(UIColor.label), style: StrokeStyle(lineWidth: 16, lineCap: .round))
								.opacity(mode == .ahead ? 0 : 1)
							
							Circle()
								.trim(from: mod(self.angle, 360) >= 180 ? (1 - abs(self.angle.remainder(dividingBy: 360)) / 360) + 0.025 : 1, to: 0.975)
								.rotation(Angle(degrees: -90))
								.stroke(Color(UIColor.label), style: StrokeStyle(lineWidth: 16, lineCap: .round))
								.opacity(mode == .ahead ? 0 : 1)
						}
						.frame(width: 312, height: 312)
						
						ZStack {
							HStack {
								Spacer()
								Circle()
									.frame(width: 16, height: 16)
									.offset(x: 8)
									.opacity(mode == .ahead ? 0 : 1)
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
								Text("\(mod(self.angle, 360))")
								Text("°")
									.foregroundColor(Color(UIColor.secondaryLabel))
								Spacer()
							}
							
							HStack {
								if mode == .right {
									Text("to your")
									Text("right")
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
				.background((mode == .ahead ? Color.green : Color(UIColor.systemBackground)).edgesIgnoringSafeArea(.all))
				.onReceive(self.location.heading) { heading in
					var diff = (heading - self.angle + 180).truncatingRemainder(dividingBy: 360) - 180
					if diff < -300 {
						diff += 360
					}
					withAnimation {
						self.angle += diff
					}
					if (mod(self.angle, 360) <= 10 || mod(self.angle, 360) >= 350){
						toggleMode(opt: true)
					} else {
						toggleMode(opt: false)
					}
				}
			}
			.navigationTitle("Qibla Direction")
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

struct Finding_Previews: PreviewProvider {
	static var previews: some View {
		Finding()
	}
}
