import SwiftUI
import GoogleMobileAds

struct TestView: View {

	let ad = AdsApi()
	
	var body: some View {
		VStack {
			Button(action: {
				ad.loadInterstitialAd()
			}, label: {
				Text("Show Ad")
			})
			Text("Hello")
		}
		.onAppear{
			ad.requestInterstitialAd(adID: "ca-app-pub-3940256099942544/4411468910")
		}
	}
	
}


#Preview {
	TestView()
}
