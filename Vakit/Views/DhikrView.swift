import SwiftUI
import SwiftData

struct DhikrView: View {
	
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	var btnBack : some View { Button(action: { self.presentationMode.wrappedValue.dismiss()}) {
		ZStack {
			RoundedRectangle(cornerRadius: 15, style: .continuous)
				.fill(Color("cardView"))
				.shadow(color: .black.opacity(0.1), radius: 24, x: 0, y: 8)
				.frame(width: 40, height: 40)
			Image(systemName: "chevron.left")
				.resizable()
				.foregroundColor(Color("cardView.title"))
				.aspectRatio(contentMode: .fit)
				.frame(width: 15, height: 15)
			//.padding(20)
		}
	}}
	
	@Environment(\.modelContext) var context
	@Query var dhikrs: [Dhikr]
	@State var selectedDhikr: Dhikr?
	
	var body: some View {
		NavigationView {
			ZStack(alignment: .top){
				Color("backgroundColor").ignoresSafeArea()
				Image("pattern")
					.frame(minWidth: 0, maxWidth: .infinity)
					.mask(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.15),  .black.opacity(0.1), .black.opacity(0)]), startPoint: .top, endPoint: .bottom))
					.opacity(0.6)
					.foregroundColor(Color("patternColor").opacity(0.4))
					.ignoresSafeArea()
				ScrollView {
					ForEach(dhikrs, id: \.self) { dhikr in
						   VStack {
							ZStack(alignment: .topLeading) {
								RoundedRectangle(cornerRadius: 15, style: .continuous)
									.fill(Color("cardView"))
									.shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 7)
									.frame(height: 150)
									.padding()
								RoundedRectangle(cornerRadius: 15, style: .continuous)
									.fill(Color("color1").opacity(0.1))
									.shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 7)
									.frame(height: 150)
									.padding()
								VStack(alignment: .leading) {
									VStack(alignment: .leading) {
										Text(dhikr.name)
											.font(.title)
											.fontWeight(.bold)
											.foregroundColor(Color("cardView.title"))
											.frame(maxWidth: .infinity, alignment: .leading)
										Text("Dhikr routine after every salah")
											.font(.headline)
											.foregroundColor(Color("cardView.subtitle"))
											.frame(maxWidth: .infinity, alignment: .leading)
									}
									.padding([.top, .leading], 30)
									Spacer()
									HStack {
										Text("\(dhikr.count)")
											.font(.largeTitle)
											.fontWeight(.bold)
											.foregroundColor(Color("cardView.title"))
											.frame(maxWidth: .infinity, alignment: .bottomLeading)
											.padding([.bottom, .leading], 30)
										Spacer()
										ZStack {
											RoundedRectangle(cornerRadius: 15, style: .continuous)
												.fill(Color("color1"))
												.frame(width: 60, height: 60)
											Image(systemName: "chevron.right")
												.resizable()
												.foregroundColor(.white)
												.aspectRatio(contentMode: .fit)
												.frame(width: 15, height: 15)
											//.padding(20)
										}
										.padding([.bottom, .trailing], 30)
										.frame(alignment: .bottomTrailing)
									}
								}
							}
							.onTapGesture {
								selectedDhikr = dhikr
							}
							.sheet(item: $selectedDhikr) { dhikr in
								DhikrCountView(dhikr: dhikr)
							}
						}
					   }
				}
				.onAppear {
					if dhikrs.isEmpty {
						let dhikr2 = Dhikr(id: UUID(), name: "After Salah", count: 99)
						context.insert(dhikr2)
					}
				}
			}
			.navigationTitle("Dhikr")
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: btnBack)
		//.toolbar(.hidden, for: .tabBar)
	}
}

struct DhikrCountView: View {
	
	@Environment(\.modelContext) var context
	@Bindable var dhikr: Dhikr
	
	var body: some View {
		ZStack(alignment: .top) {
			Color("backgroundColor").ignoresSafeArea()
			Capsule()
			   .fill(Color.secondary)
			   .opacity(0.5)
			   .frame(width: 35, height: 5)
			   .padding(10)
			VStack {
				Text("\(dhikr.count.description)x")
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.leading, 30)
					.font(.system(size: 100))
					.fontWeight(.bold)
					.padding(.top, 50)
				Spacer()
				ZStack {
					RoundedRectangle(cornerRadius: 200, style: .continuous)
						.fill(Color("cardView"))
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						.frame(width: 360, height: 360)
					Circle()
						.trim(from: 0, to: 1.0)
						.rotation(.degrees(-90))
						.stroke(Color("color1"), style: StrokeStyle(lineWidth: 50, lineCap: .round))
						.frame(width: 300, height: 300)
					Circle()
						.trim(from: 0, to: 0.55)
						.rotation(.degrees(-90))
						.stroke(Color("color2"), style: StrokeStyle(lineWidth: 38, lineCap: .round))
						.frame(width: 300, height: 300)
					Text("Press")
						.font(.largeTitle)
				}
				.onTapGesture {
					dhikr.count += 1
				}
			}
			.frame(maxWidth: .infinity)
		}
	}
}

#Preview {
	DhikrView()
		.modelContainer(for: [Dhikr.self])
}
/*
#Preview {
	let dhikr = Dhikr(id: UUID(), name: "After Salah", count: 99)
	DhikrCountView(dhikr: dhikr)
}
 */
