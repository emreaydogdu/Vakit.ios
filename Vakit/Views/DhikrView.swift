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
				ForEach(dhikrs + Dhikr.preDefined, id: \.self) { dhikr in
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
			.contentMargins(.bottom, 90, for: .scrollContent)
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
				Button(action: {add.toggle()}, label: {
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
				})
				.foregroundColor(Color("cardView.title"))
				.sheet(isPresented: $add) {
					DhikrAddView()
				}
				.padding(.horizontal)
				.padding(.bottom, 6)
			}
		}
		.navigationBarBackButtonHidden(true)
	}
}

struct DhikrCountView: View {
	
	@Environment(\.modelContext) var context
	@Bindable var dhikr: Dhikr
	
	var body: some View {
		ZStack(alignment: .top) {
			PatternBG(pattern: false)
			Capsule().fill(Color.secondary).frame(width: 35, height: 5).padding(.top, 12)
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

struct DhikrAddView: View {
	
	@Environment(\.modelContext) var context
	@Environment(\.dismiss) var dismiss
	@State private var add = false
	@State private var preDefined = false
	@State private var original = ""
	@State private var translation = ""
	@State private var amount = ""
	@State private var show = false
	@State private var defaultv: CGPoint = .zero
	@State private var selectedDhikr: Dhikr?
	
	var body: some View {
		ZStack{
			PatternBG(pattern: false)
			VStack {
				Capsule().fill(Color.secondary).frame(width: 35, height: 5).padding(.top, 12)
				Spacer()
			}
			VStack{
				FormSection(header: "SELECT DHIKR", footer: "Select a predefined Dhikr from the List or create a new one right below") {
					Button(action: {preDefined.toggle()}, label: {
						ZStack(alignment: .center) {
							RoundedRectangle(cornerRadius: 13, style: .continuous)
								.fill(Color("cardView"))
								.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
								.padding(5)
							HStack {
								Text("Select Dhikr")
									.font(.headline)
									.fontWeight(.bold)
									.foregroundColor(Color("cardView.title"))
								Spacer()
								Image("ic_share")
									.resizable()
									.imageScale(.small)
									.frame(width: 30, height: 30)
									.rotationEffect(.degrees(45))
									.foregroundColor(Color("cardView.title"))
							}.padding(.horizontal, 22)
						}
						.padding(.horizontal)
					})
					.sheet(isPresented: $preDefined){
						ZStack{
							PatternBG(pattern: false)
							VStack {
								Capsule().fill(Color.secondary).frame(width: 35, height: 5).padding(.top, 12)
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
											 }
											 .padding(22)
										 }
										 .onTapGesture {
											 selectedDhikr = dhikr
											 preDefined.toggle()
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
								Spacer()
							}
						}
					}
					.onChange(of: selectedDhikr){ dhikr in
						original = dhikr!.nameAr
						translation = dhikr!.name
					}
				}
				
				FormSection(header: "Create Dhikr", footer: "Please provide the original spelling of your dhikr and the translation"){
					VStack {
						ZStack(alignment: .center) {
							RoundedRectangle(cornerRadius: 13, style: .continuous)
								.fill(Color("cardView"))
								.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
								.padding(5)
							HStack {
								TextField("Original", text: $original)
									.font(.headline)
									.foregroundColor(Color("cardView.title"))
									.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
									.padding(.vertical, 10)
							}.padding(.horizontal, 22)
						}
						.padding(.horizontal)
						ZStack(alignment: .center) {
							RoundedRectangle(cornerRadius: 13, style: .continuous)
								.fill(Color("cardView"))
								.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
								.padding(5)
							HStack {
								TextField("Translation", text: $translation)
									.font(.headline)
									.foregroundColor(Color("cardView.title"))
									.padding(.vertical, 10)
							}.padding(.horizontal, 22)
						}
						.padding(.horizontal)
					}
				}
				
				FormSection(header: "Choose Amount", footer: ""){
					VStack {
						ZStack(alignment: .center) {
							RoundedRectangle(cornerRadius: 13, style: .continuous)
								.fill(Color("cardView"))
								.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
								.padding(5)
							HStack {
								TextField("99", text: $amount)
									.font(.headline)
									.foregroundColor(Color("cardView.title"))
									.padding(.vertical, 10)
							}.padding(.horizontal, 22)
						}
						.padding(.horizontal)
					}
				}
				
				Spacer()
				Button(action: {
					let dhikr2 = Dhikr(id: UUID(), name: translation, nameAr: original, count: Int(amount)!)
					context.insert(dhikr2)
					
				}, label: {
					ZStack(alignment: .center) {
						RoundedRectangle(cornerRadius: 16, style: .continuous)
							.fill(Color(hex: "#C1D2E7"))
							.shadow(color: .black.opacity(0.15), radius: 24, x: 0, y: 8)
							.frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
							.padding(5)
						HStack {
							Text("Create")
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
				})
				.foregroundColor(Color("cardView.title"))
				.padding(.horizontal)
				.padding(.bottom, 6)
			}
			.padding(.top, 20)
		}
	}
}

struct FormSection<Content: View>: View {
	var header: String
	var footer: String
	var content: () -> Content
	
	var body: some View {
		Section(
			header: Text("\(header)".uppercased())
				.font(.subheadline)
				.fontWeight(.bold)
				.foregroundColor(Color("cardView.subtitle"))
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.leading, 38)
				.padding(.top, 20),
			footer: Text("\(footer)")
				.font(.subheadline)
				.foregroundColor(Color("cardView.subtitle"))
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.horizontal, 38))
		{
			content()
		}
	}
}

#Preview {
	DhikrAddView()
		.modelContainer(for: [Dhikr.self])
}
/*
 #Preview {
 DhikrView()
 .modelContainer(for: [Dhikr.self])
 }
 
 #Preview {
 let dhikr = Dhikr(id: UUID(), name: "After Salah", count: 99)
 DhikrCountView(dhikr: dhikr)
 }
 */
