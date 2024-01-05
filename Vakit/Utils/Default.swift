import Foundation
import SwiftUI

struct PatternBG : View {
	var body: some View {
		Color("backgroundColor").ignoresSafeArea()
		Image("pattern")
		   .frame(alignment: .top)
		   .mask(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.15),  .black.opacity(0.1), .black.opacity(0)]), startPoint: .top, endPoint: .bottom))
		   .opacity(0.9)
		   .foregroundColor(Color("patternColor").opacity(0.4))
		   .ignoresSafeArea()
	}
}

#Preview{
	PatternBG()
}
