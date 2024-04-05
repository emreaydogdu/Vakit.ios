import SwiftUI

struct SplashScreen: View {
	
	@State private var showSplash: Bool = false
	@State private var showBG: Bool = true
	
	var body: some View {
		ZStack(alignment: .center){
			if(showBG){
				Color.black.ignoresSafeArea()
			}
			if(showSplash){
				ZStack {
					Color.black.ignoresSafeArea()
					Image("splashscreen")
						.resizable()
						.aspectRatio(contentMode: .fit)
						
				}
			}
		}
		.ignoresSafeArea()
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				withAnimation {
					self.showSplash.toggle()
				}
			}
			Task{
				try! await Task.sleep(for: .seconds(1.4))
				self.showBG.toggle()
				withAnimation {
					self.showSplash.toggle()
				}
			}
		}
	}
}

#Preview {
	SplashScreen()
}
