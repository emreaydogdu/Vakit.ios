import SwiftUI
import SwiftData

struct DhikrView: View {
	
	@Environment(\.modelContext) var context
	@Query var dhikrs: [Dhikr]
	@State var selectedDhikr: Dhikr?
	@State private var add = false
	@State private var show = false
	@State private var defaultv: CGPoint = .zero
	
	var body: some View {
		ZStack(alignment: .top){
			PatternBG(pattern: false)
			ScrollView {
				ForEach(Dhikr.preDefined, id: \.self) { dhikr in
					VStack {
						ZStack(alignment: .topLeading) {
							RoundedRectangle(cornerRadius: 20, style: .continuous)
								.fill(Color("cardView.sub"))
								.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
							RoundedRectangle(cornerRadius: 16, style: .continuous)
								.fill(Color("cardView"))
								.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
								.padding(5)
							HStack{
								Spacer()
								VStack{
									Image("ic_share")
										.resizable()
										.imageScale(.small)
										.frame(width: 28, height: 28)
										.foregroundColor(Color("cardView.title"))
										.padding()
									Spacer()
								}
							}
							VStack{
								Text(dhikr.nameAr)
									.font(.title)
									.padding(.top, 12)
								Text(dhikr.name)
									.font(.headline)
									.fontWeight(.bold)
									.foregroundColor(Color("textColor"))
									.frame(maxWidth: .infinity, alignment: .leading)
									.padding(.top, 1)
								Text("\(dhikr.count)")
									.font(.body)
									.foregroundColor(Color("subTextColor"))
									.frame(maxWidth: .infinity, alignment: .leading)
							}
							.padding(22)
						}
						.onTapGesture {
							selectedDhikr = dhikr
						}
						.sheet(item: $selectedDhikr) { dhikr in
							DhikrCountView(dhikr: dhikr)
						}
					}
					.padding(.horizontal)
					.padding(.bottom, 6)
				}
				.background(GeometryReader { geometry in
					Color.clear
						.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin)
						.onAppear{
							defaultv = geometry.frame(in: .named("scroll")).origin
						}
				})
				.onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
					withAnimation(.linear(duration: 0.1)){
						show = value.y < defaultv.y - 30.0
					}
				}
			}
			.coordinateSpace(name: "scroll")
			.contentMargins(.top, 80, for: .scrollContent)
			.onAppear {
				if dhikrs.isEmpty {
					//let dhikr2 = Dhikr(id: UUID(), name: "Allahu Akbar",  nameAr: "الله أَكْبَر", count: 99)
					//context.insert(dhikr2)
				} else {
					//context.delete(dhikrs.first!)
				}
			}
			ToolbarBck(title: "Dhikr", show: $show)
			VStack{
				Spacer()
				ZStack(alignment: .center) {
					RoundedRectangle(cornerRadius: 16, style: .continuous)
						.fill(Color(hex: "#C1D2E7"))
						.shadow(color: .black.opacity(0.15), radius: 24, x: 0, y: 8)
						.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
						.padding(5)
					HStack {
						Text("Create a new Dhikr")
							.font(.headline)
							.fontWeight(.bold)
							.foregroundColor(Color(hex: "#141414"))
						Spacer()
						Image("ic_add")
							.resizable()
							.imageScale(.small)
							.frame(width: 30, height: 30)
							.foregroundColor(Color(hex: "#141414"))
					}.padding(.horizontal, 22)
				}
			}
			.onTapGesture {
				add.toggle()
			}
			.sheet(isPresented: $add, content: {
				DhikrAddView()
			})
			.padding(.horizontal)
			.padding(.bottom, 6)
		}
		.navigationBarBackButtonHidden(true)
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
