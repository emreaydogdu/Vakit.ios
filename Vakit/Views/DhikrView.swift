import SwiftUI
import SwiftData
import SwipeActions
import Combine

struct DhikrView: View {
	
	@Environment(\.modelContext) var context
	@Query var dhikrs: [Dhikr]
	@State var selectedDhikr: Dhikr?
	@State var deletedDhikr: Dhikr?
	@State private var add = false
	@State private var show = false
	@State private var isPresentingConfirm = false
	@State private var defaultv: CGPoint = .zero
	
	var body: some View {
		ZStack(alignment: .top){
			PatternBG(pattern: false)
			ScrollView {
				SwipeViewGroup {
					ForEach(dhikrs.reversed() + Dhikr.preDefined, id: \.id) { dhikr in
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
						.padding(.bottom, 6)
						.if(!dhikr.predef){ content in
							SwipeView {
								content
							} trailingActions: { _ in
									ZStack{
										RoundedRectangle(cornerRadius: 16, style: .continuous)
											.fill(Color.red)
											.padding(10)
										
										Image("ic_trash")
											.resizable()
											.imageScale(.small)
											.frame(width: 28, height: 28)
											.foregroundColor(Color.white)
											.padding()
											.onTapGesture{
												deletedDhikr = dhikr
												isPresentingConfirm.toggle()
											}
									}
									.confirmationDialog("Are you sure?",  isPresented: $isPresentingConfirm, titleVisibility: .visible) {
										Button("Delete", role: .destructive) {
											withAnimation(.spring()){
												context.delete(deletedDhikr!)
											}
										}
									}
								}
								.swipeMinimumDistance(10)
								.swipeReadyToExpandPadding(50)
								.swipeActionCornerRadius(16)
								.swipeActionsMaskCornerRadius(16)
						}
						
						.padding(.horizontal)
					}
					.transition(AnyTransition.scale)
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
			}
			.animation(.easeInOut, value: dhikrs )
			.coordinateSpace(name: "scroll")
			.contentMargins(.top, 80, for: .scrollContent)
			.contentMargins(.bottom, 90, for: .scrollContent)
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
	@FocusState private var focusItem: Bool
	
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
					.onChange(of: selectedDhikr) {
						original = selectedDhikr!.nameAr
						translation = selectedDhikr!.name
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
									.focused($focusItem)
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
									.focused($focusItem)
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
									.keyboardType(.numberPad)
									.focused($focusItem)
									.onReceive(Just(amount)) { newValue in
										let filtered = newValue.filter { "0123456789".contains($0) }
										if filtered != newValue {
											self.amount = filtered
										}
									}
							}.padding(.horizontal, 22)
						}
						.padding(.horizontal)
					}
				}
				
				Spacer()
				Button(action: {
					if (translation != "" && original != "" && amount != ""){
						context.insert(Dhikr(id: UUID(), name: translation, nameAr: original, count: 0, amount: Int(amount)!, predef: false))
						dismiss()
					}
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
		.onTapGesture{
			focusItem = false
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

struct DhikrCountView: View {
	
	@Bindable var dhikr: Dhikr
	@State var disable = true
	
	var body: some View {
		ZStack(alignment: .top) {
			PatternBG(pattern: false)
			Capsule().fill(Color.secondary).frame(width: 35, height: 5).padding(.top, 12)
			VStack {
				ZStack() {
					RoundedRectangle(cornerRadius: 13, style: .continuous)
						.fill(Color("cardView"))
						.padding(5)
					VStack {
						Text("\(dhikr.nameAr)")
							.font(.headline)
							.foregroundColor(Color("cardView.title"))
							.frame(maxWidth: .infinity, alignment: .leading)
							.environment(\.layoutDirection, .rightToLeft)
						Text("\(dhikr.name)")
							.font(.headline)
							.foregroundColor(Color("cardView.title"))
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.top, 5)
					}
					.padding(22)
				}
				.fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
				.padding(.top, 50)
				.padding(.horizontal)
				Text("\(dhikr.count.description)x")
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.leading, 30)
					.font(.system(size: 100))
					.fontWeight(.bold)
				Spacer()
				ZStack {
					RoundedRectangle(cornerRadius: 200, style: .continuous)
						.fill(Color("cardView.sub"))
						.shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
						.frame(width: 360, height: 360)
					Circle()
						.trim(from: 0, to: 1.0)
						.rotation(.degrees(-90))
						.stroke(Color("cardView"), style: StrokeStyle(lineWidth: 50, lineCap: .round))
						.frame(width: 300, height: 300)
					Circle()
						.trim(from: 0, to: CGFloat(dhikr.count)/CGFloat(dhikr.amount))
						.rotation(.degrees(-90))
						.stroke(Color(hex: "#C1D2E7"), style: StrokeStyle(lineWidth: 40, lineCap: .round))
						.frame(width: 300, height: 300)
					Text("Press")
						.font(.largeTitle)
				}
				.allowsHitTesting(disable)
				.onTapGesture {
					if (dhikr.count < dhikr.amount - 1){
						UIImpactFeedbackGenerator(style: .soft).impactOccurred()
						withAnimation{
							dhikr.count += 1
						}
					}
					else{
						disable.toggle()
						withAnimation{
							UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
								UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
							}
							dhikr.count += 1
						} completion: {
							withAnimation{
								dhikr.count = 0
								disable.toggle()
							}
						}
					}
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
 .modelContainer(for: [Dhikr.self])
 }
 
 #Preview {
 let dhikr = Dhikr(id: UUID(), name: "After Salah", count: 99)
 DhikrCountView(dhikr: dhikr)
 }
 */

