import SwiftUI

struct PrayerTimeTableItem: View {
	
	let prayerName: LocalizedStringKey
	let prayerTime: String
	let prayerIcon: String
	@State var isPlayin = true
	
	var body: some View {
		VStack{
			VStack{
				ZStack{
					VStack(alignment: .center){
						Button(action: {
							isPlayin.toggle()
						}, label: {
							Image(prayerIcon)
								.resizable()
								.imageScale(.small)
								.frame(width: 38, height: 38)
								.foregroundColor(Color("cardView.title"))
								.padding(.bottom, 5)
						})
						Text(prayerTime)
							.font(.headline)
							.fontWeight(.bold)
						Text(prayerName)
							.font(.footnote)
							.foregroundColor(Color("cardView.subtitle"))
						
					}
					//.padding(.horizontal, 15)
					//.padding(.vertical, 20)
				}
			}
			.padding()
		}
	}
}

struct PrayerTimeTableItem_Previews: PreviewProvider {
	static var previews: some View {
		PrayerTimeTableItem(prayerName: LocalizedStringKey("ttFajr"), prayerTime: "04:17:00", prayerIcon: "ic_sun3")
	}
}
