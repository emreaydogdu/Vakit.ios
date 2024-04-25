import SwiftUI

struct PrayerTimeHeader: View {
	
	let prayer = PrayerTimesClass().decodePrayer(key: "prayerTimes1")
	let prayer2 = PrayerTimesClass().decodePrayer(key: "prayerTimes2")
	let prayerName: String
	let nextPrayerName: String
	let prayerTime: Date
	let location: String
	let currentDate = Date()
	let gregorianCalendar = Calendar(identifier: .gregorian)
	let hijriCalender = Calendar(identifier: .islamicUmmAlQura)
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(.ultraThinMaterial)
				//.shadow(color: .black.opacity(0.01), radius: 50, x: 0, y: 8)
			/*
			HStack(alignment: .bottom){
				VStack(alignment: .center, spacing: 20){
					HStack{
						Text("\(location)")
							.bold()
						Image(systemName: "location.circle.fill")
							.foregroundColor(.white)
							.frame(alignment: .leading)
					}
					.padding(3)
					.padding(.horizontal, 6)
					.foregroundColor(.white)
					.background(.black)
					.clipShape(.capsule)
					.frame(maxWidth: .infinity, alignment: .leading)
					
					Text("\(prayerTime, style: .timer)")
						.font(.custom("Montserrat-Bold ", size: 44.0))
						.frame(maxWidth: .infinity, alignment: .leading)
					
					ProgressView(value: 0.5)
						.frame(height: 8.0)
						.scaleEffect(x: 1, y: 2, anchor: .center)
						.clipShape(RoundedRectangle(cornerRadius: 6))
						.tint(.black)
					
					HStack(alignment: .bottom){
						VStack {
							Text("Current")
								.font(.subheadline)
								.frame(maxWidth: .infinity, alignment: .leading)
							
							Text(LocalizedStringKey(prayerName))
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(.black)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
						VStack {
							Text("Next")
								.font(.subheadline)
								.frame(maxWidth: .infinity, alignment: .leading)
							
							Text(LocalizedStringKey(nextPrayerName))
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(.black)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
					}
				}
				.padding(.vertical)
				.padding(.leading)
				Spacer()
				Image("tst")
					.resizable()
					.frame(width: 150,height: 180)
					.clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 0.0, bottomLeading: 0.0, bottomTrailing: 25.0, topTrailing: 0.0), style: .continuous))
			}
			.frame(maxWidth: .infinity)
			 */
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
						Text("\(location)")
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
							Text("00꞉")
								.font(.largeTitle)
								.fontWeight(.semibold)
								.monospacedDigit()
								.foregroundColor(Color(uiColor: .systemGray3))
							+ Text("04:")
								.font(.largeTitle)
								.fontWeight(.semibold)
								.monospacedDigit()
							+ Text("45")
								.font(.largeTitle)
								.fontWeight(.semibold)
								.monospacedDigit()
							Spacer()
						}
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
							Text("Ikindi")
								.font(.headline)
								.fontWeight(.bold)
							Text("04:34")
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(Color(hex: "#797982"))
							Spacer()
							Text("···")
								.font(.headline)
								.fontWeight(.bold)
								.opacity(0.5)
							Spacer()
							Text("05:16")
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(Color(hex: "#797982"))
							Text("Yatsi")
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
	PrayerTimeHeader(prayerName: "Yatsi", nextPrayerName: "Imsak", prayerTime: Date(), location: "Berlin")
}
