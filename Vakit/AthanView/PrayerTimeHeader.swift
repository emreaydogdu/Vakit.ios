import SwiftUI

struct CardView: View {
	var body: some View {
		ZStack {
			ZStack {
				Image("gradient1")
					.resizable()
					.aspectRatio(contentMode: .fit)
				
			}
			.cornerRadius(10)
			.overlay(
				RoundedRectangle(cornerRadius: 15)
					.stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.2), lineWidth: 1)
			)
			//.padding([.top, .horizontal], 0)
			
			Image("mosque1")
				.resizable()
				.frame(width: 200, height: 200, alignment: .leading)
				.offset(y: -100)
				.offset(x: 100)
			//.padding(.top, -200)
			//.padding(.leading, 180)
			
			GlassMorphicCard()
				.padding(.top, 90)
			
			HStack {
				VStack(alignment: .leading) {
					Text("14 : 45 : 34")
						.font(.title)
						.fontWeight(.black)
						.foregroundColor(.black)
						.lineLimit(3)
				}
				
				Spacer()
			}
			.padding()
			.padding(.horizontal, 15)
			.padding(.top, 70)
			
		}
		.frame(height: 300)
		//.background(.red)
		
	}
	
	@ViewBuilder
	func GlassMorphicCard() -> some View {
		ZStack{
			CustomBlurView(effect: .systemUltraThinMaterialDark){ view in
				
			}
			.clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
		}
		.padding(.horizontal, 15)
		.frame(height: 100, alignment: .bottom)
	}
}

struct CustomBlurView: UIViewRepresentable {
	var effect: UIBlurEffect.Style
	var onChange: (UIVisualEffectView)->()
	
	func makeUIView(context: Context) -> UIVisualEffectView {
		let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
		return view
	}
	
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		DispatchQueue.main.async {
			onChange(uiView)
		}
	}
}

extension UIVisualEffectView {
	var backDrop: UIView?{
		return subView(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
	}
	
	var gaussianBlur: NSObject?{
		return backDrop?.value(key: "filters", filter: "gaussianBlur")
	}
	
}
extension UIView {
	func subView(forClass: AnyClass?)->UIView?{
		return subviews.first { view in
			type(of: view) == forClass
		}
	}
}
extension NSObject{
	func value(key: String, filter: String)->NSObject?{
		(value(forKey: key) as? [NSObject])?.first(where: { obj in
			return obj.value(forKeyPath: "filterType") as? String == filter
		})
	}
}

struct PrayerTimeHeader: View {
	
	let prayerName: String
	let prayerTime: Date
	let location: String
	let currentDate = Date()
	let gregorianCalendar = Calendar(identifier: .gregorian)
	let hijriCalender = Calendar(identifier: .islamicUmmAlQura)
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 25)
				.fill(Color("cardView"))
				.frame(maxHeight: 180)
				.padding()
			VStack(alignment: .center, spacing: 20){
				VStack(spacing: 10){
					HStack{
						Text("\(location)")
							.bold()
						Image(systemName: "location.circle.fill")
							.foregroundColor(Color("color"))
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					.padding(.horizontal)
					
					VStack{
						Text("\(prayerName) Time")
							.font(.title)
							.fontWeight(.bold)
							.foregroundColor(Color("color"))
							.frame(maxWidth: .infinity, alignment: .leading)
					}
					.padding(.horizontal)
					
					VStack {
						Text("\(prayerTime, style: .timer)")
							.font(.system(size: 64))
							.fontWeight(.semibold)
							.padding(.bottom)
					}
				}
				.padding(.top)
			}
			.padding()
		}
	}
}

#Preview {
	PrayerTimeHeader(prayerName: "Imsak", prayerTime: Date(), location: "Berlin")
}
