import Foundation
import GoogleMobileAds
import UIKit

final class AdsApi: NSObject, GADFullScreenContentDelegate {
	
	var open: 			GADAppOpenAd?
	var interstitial: 	GADInterstitialAd?
	let request = 		GADRequest()
	var loadTime = Date()
	
	func requestAppOpenAd() {
		GADAppOpenAd.load(withAdUnitID: "ca-app-pub-3940256099942544/5575463023", request: request,  completionHandler: { (appOpenAdIn, error) in
			if let error = error {
				print("Failed to load interstitial ad with error: \(error.localizedDescription)")
				return
			}
			self.open = appOpenAdIn
			self.open?.fullScreenContentDelegate = self
			self.loadTime = Date()
			self.loadOpenAd()
		})
	}
	func loadOpenAd() {
		if let open = self.open {
			let root = UIApplication.shared.windows.first?.rootViewController
			open.present(fromRootViewController: root!)
		} else {
			print("Ad wasn't ready")
		}
	}
	
	func requestInterstitialAd(adID: String) {
		GADInterstitialAd.load(withAdUnitID: adID, request: request, completionHandler: { [self] ad, error in
			if let error = error {
				print("Failed to load interstitial ad with error: \(error.localizedDescription)")
				return
			}
			self.interstitial = ad
		})
	}
	func loadInterstitialAd(){
		if let interstitial = self.interstitial {
			let root = UIApplication.shared.windows.first?.rootViewController
			interstitial.present(fromRootViewController: root!)
		} else {
			print("Ad wasn't ready")
		}
	}
	
	
	func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
		let now = Date()
		let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
		let secondsPerHour = 3600.0
		let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
		return intervalInHours < Double(thresholdN)
	}
	
	func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
		print("[OPEN AD] Failed: \(error)")
		requestAppOpenAd()
	}
	
	func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
		print("[OPEN AD] Ad dismissed")
	}
	
	func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
		print("[OPEN AD] Ad did present")
	}
}
