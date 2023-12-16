import SwiftUI

struct AthanHome: View {
    var body: some View {
        AthanView(prayerClass: PrayerTimesClass())
     
    }
}

struct AthanHome_Previews: PreviewProvider {
    static var previews: some View {
        AthanHome()
    }
}
