import SwiftUI

struct AthanTimeTable: View {
    
    let gridItems = Array(repeating: GridItem(.flexible()), count: 3)
    let prayerClass: PrayerTimesClass
    
    var body: some View {
        VStack(alignment: .leading){
            LazyVGrid(columns: gridItems, spacing: 6) {
                ForEach(0..<1) { _ in
                    PrayerTimeTableItem(prayerName: LocalizedStringKey("ttFajr"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.fajr))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
                        .background(Color("cardView"))
                        .cornerRadius(25)
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
                    PrayerTimeTableItem(prayerName: LocalizedStringKey("ttSunrise"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.sunrise))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
						.background(Color("cardView"))
                        .cornerRadius(25)
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
                    PrayerTimeTableItem(prayerName: LocalizedStringKey("ttDhur"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.dhuhr))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
						.background(Color("cardView"))
                        .cornerRadius(25)
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
                    PrayerTimeTableItem(prayerName: LocalizedStringKey("ttAsr"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.asr))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
						.background(Color("cardView"))
                        .cornerRadius(25)
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
                    PrayerTimeTableItem(prayerName: LocalizedStringKey("ttMaghrib"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.maghrib))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
						.background(Color("cardView"))
                        .cornerRadius(25)
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
                    PrayerTimeTableItem(prayerName: LocalizedStringKey("ttIsha"), prayerTime: "\(prayerClass.formattedPrayerTime(prayerClass.prayers?.isha))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .aspectRatio(1.0, contentMode: .fill)
						.background(Color("cardView"))
                        .cornerRadius(25)
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
                    
                }
            }
        }
    }
}

struct AthanTimeTable_Previews: PreviewProvider {
    static var previews: some View {
        AthanTimeTable(prayerClass: PrayerTimesClass())
    }
}
