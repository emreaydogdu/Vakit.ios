import SwiftUI

struct PrayerTimeHeader: View {
	
	let prayer: PrayerTime?
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	@State private var hour = 0
	@State private var mins = 0
	@State private var secs = 0

	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(.ultraThinMaterial)
				//.shadow(color: .black.opacity(0.01), radius: 50, x: 0, y: 8)
			VStack(spacing: 0){
				ZStack {
					RoundedRectangle(cornerRadius: 16, style: .continuous)
						.fill(.regularMaterial)
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						.padding(5)
					VStack {
						HStack{
							Spacer()
							ZStack {
								Circle()
									.stroke(Color(uiColor: .systemGray4), lineWidth: 10)
								.frame(maxWidth: 80, alignment: .leading)
								Circle()
									.trim(from: 0, to: 0.25)
									.stroke(Color(hex: "#797982"), style: StrokeStyle( lineWidth: 10, lineCap: .round))
									.frame(maxWidth: 80, alignment: .leading)
								Image("ic_sun2")
									.resizable()
									.frame(maxWidth: 30, maxHeight: 30, alignment: .leading)
									.foregroundColor(Color(hex: "#797982"))
									.rotationEffect(.degrees(90))
							}
							.rotationEffect(.degrees(-90))
						}
						Spacer()
					}
					.padding(25)
					VStack {
						Text("\(prayer!.city)")
							.font(.headline)
							.fontWeight(.bold)
							.foregroundColor(Color("textColor"))
							.frame(maxWidth: .infinity, alignment: .leading)
						HStack{
							Text("Vaktin cikmasina")
								.font(.footnote)
								.fontWeight(.semibold)
								.frame(maxWidth: .infinity, alignment: .leading)
							Spacer()
						}
						.padding(.top)

						HStack{
							Text(String(format: "%02d:", hour))
								.font(.largeTitle)
								.fontWeight(.semibold)
								.monospacedDigit()
								.foregroundColor(hour == 0 ? Color(uiColor: .systemGray3) : Color.black)
							+ Text(String(format:"%02d:", mins))
								.font(.largeTitle)
								.fontWeight(.semibold)
								.monospacedDigit()
								.foregroundColor(mins == 0 ? Color(uiColor: .systemGray3) : Color.black)
							+ Text(String(format:"%02d", secs))
								.font(.largeTitle)
								.fontWeight(.semibold)
								.monospacedDigit()
							Spacer()
						}
						.onReceive(timer, perform: { _ in
							let difference = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: prayer!.nextPrayerDate()!)
							self.hour = difference.hour!
							self.mins = difference.minute!
							self.secs = difference.second!
						})
						HStack{
							Text("Current")
								.font(.caption2)
								.foregroundColor(Color(hex: "#797982"))
								.frame(maxWidth: .infinity, alignment: .leading)
							Spacer()
							Text("Next")
								.font(.caption2)
								.foregroundColor(Color(hex: "#797982"))
								.frame(maxWidth: .infinity, alignment: .trailing)
						}
						.padding(.top)
						HStack{
							Text(LocalizedStringKey(prayer!.currentPrayer()!))
								.font(.headline)
								.fontWeight(.bold)
							Text("\(prayer!.currentPrayerDate() == nil ? "fehler" : prayer!.currentPrayerDate()!.formatted(date: .omitted, time: .shortened))")
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(Color(hex: "#797982"))
							Spacer()
							//Text("···")
							Text("")
								.font(.headline)
								.fontWeight(.bold)
								.opacity(0.5)
							Spacer()
							Text("\(prayer!.nextPrayerDate() == nil ? "fehler" : prayer!.nextPrayerDate()!.formatted(date: .omitted, time: .shortened))")
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(Color(hex: "#797982"))
							Text(LocalizedStringKey(prayer!.nextPrayer()!))
								.font(.headline)
								.fontWeight(.bold)
						}
						/*
						ProgressView(value: 50, total: 100)
							.progressViewStyle(BarProgressStyle(height: 30.0, radius: 10.0))
							.padding(.bottom, 14)
						 */
					}
					.padding(22)
				}

				ZStack {
					RoundedRectangle(cornerRadius: 16, style: .continuous)
						.fill(.regularMaterial)
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						.padding(5)
					AthanTimeTable(prayer: prayer)
						.padding()
				}

				HStack{
					Image(systemName: "info.circle.fill")
						.resizable()
						.frame(maxWidth: 15, maxHeight: 15, alignment: .leading)
					Text("Allocating total points")
						.font(.footnote)
						.fontWeight(.medium)
						.foregroundColor(Color(hex: "#121212"))
					Spacer()
					Button(action: {}) {
						Text("Notifications")
							.font(.footnote)
							.fontWeight(.medium)
							.foregroundColor(Color(hex: "#121212"))
						.padding(.horizontal)
						.padding(.vertical, 5)
						.background(
							Capsule()
								.strokeBorder(Color(hex: "#121212").opacity(0.3), lineWidth: 1.0)
								.clipped()
						)
						.clipShape(Capsule())
					}
				}
				.padding(.vertical)
				.padding(.horizontal, 14)
			}
		}
		.padding()
	}
}

#Preview {
	PrayerTimeHeader(prayer: PrayerTime(city: "Berlin"))
}
