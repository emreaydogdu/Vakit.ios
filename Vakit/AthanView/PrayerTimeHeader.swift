import SwiftUI

struct PrayerTimeHeader: View {
	
	let prayerName: String
	let nextPrayerName: String
	let prayerTime: Date
	let location: String
	let currentDate = Date()
	let gregorianCalendar = Calendar(identifier: .gregorian)
	let hijriCalender = Calendar(identifier: .islamicUmmAlQura)
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 25)
				.fill(Color("cardView"))
				.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
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
						.font(.system(size: 44))
						.fontWeight(.semibold)
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
							
							Text("\(prayerName)")
								.font(.headline)
								.fontWeight(.bold)
								.foregroundColor(.black)
								.frame(maxWidth: .infinity, alignment: .leading)
						}
						VStack {
							Text("Next")
								.font(.subheadline)
								.frame(maxWidth: .infinity, alignment: .leading)
							
							Text("\(nextPrayerName)")
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
		}
		.padding()
	}
}

#Preview {
	PrayerTimeHeader(prayerName: "Yatsi", nextPrayerName: "Imsak", prayerTime: Date(), location: "Berlin")
}
